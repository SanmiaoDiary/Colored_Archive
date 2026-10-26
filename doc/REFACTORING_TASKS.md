# ColoredArchive 重构任务清单

> 本文件记录项目当前需要完成的改造任务，按优先级排列。
> 综合仓库审查报告（2026-08）与重构计划。
> 作者：SanmiaoDiary

---

## P0 — 致命问题（会导致运行错误）

### 任务 1 — 重写 `game/assets/code/character.gd`

- [x]（已解决）无需重写保留原版  
**理由：**
- 当前代码使用字典存储状态（`{"selection": false, "action": "", "move": false}`），`selection` 和 `action` 字段从未被使用，逻辑分散在多处难以维护。
- `_process` 中调用 `move_and_slide()` 是错误做法，移动逻辑必须在 `_physics_process` 物理帧中执行。
- `all_characters` 变量是重构时的残留：角色数据现在由 `character_manager` 通过 `setup()` 函数直接传入，角色节点自己持有这份引用没有任何用途，可以删除。
- `_ready` 中使用 `await` 但不处理空 texture 路径，会导致 `Sunaookami Shiroko` 等无贴图角色运行时崩溃。
- 缺少 `_exit_tree` 清理，调试导航线可能泄漏。

**具体改动：**
1. 删除 `var state = {"selection":false, "action":"", "move":false}` 整个字典
2. 新增 `enum State { IDLE, MOVING, ATTACKING, DYING }` + `var current_state := State.IDLE`
3. 删除 `func state_machine()`，在 `_physics_process` 中用 `match current_state` 分发
4. 新增统一 `func transition(to: State)` 函数，旧状态清理和新状态初始化都写在这里
5. `_process` 改为 `_physics_process`
6. `_ready` 中给 `texture_path` 加空字符串判断保护
7. 删除 `var all_characters`
8. 新增 `_exit_tree` 强制关闭 `NavigationAgent2D.debug_enabled`

---

### 任务 2 — 修复 `game/assets/code/character_manager.gd`

**理由：**
- `_ready()` 开头那段清场循环的初衷是：**热加载模组时防止模组错误写入数据残留**。这个思路是对的，但当前实现位置有问题——`have_characters` 在 `_ready` 时确实是空字典，这段代码永远不会执行。正确做法是把清场逻辑移到一个专门的 `reload_mods()` 或 `clear_all_characters()` 函数里，由热加载流程主动调用，而不是放在 `_ready` 里假装有效。
- `create_character()` 缺少 ID 合法性校验，传入不存在的 id 会直接 KeyError 崩溃。
- 同 id 角色被重复创建时，旧实例会变成孤儿节点（没有被 queue_free），造成内存泄漏。
- 目前没有批量创建角色的接口，后续增援系统无法直接使用。

**具体改动：**
1. 将 `_ready()` 开头的清场循环提取为独立函数 `func clear_all_characters()`，保留代码供热加载调用，同时在 `_ready()` 中也调用一次：
   ```gdscript
   func _ready() -> void:
       clear_all_characters()  # 防止热加载残留，保证初始状态干净
       create_character(...)
   
   func clear_all_characters() -> void:
       for key in have_characters.keys():
           delete_character(key)
   ```
2. 在 `create_character()` 开头加 ID 校验：
   ```gdscript
   if not all_characters.has(id):
       push_error("CharacterManager: unknown character id '%s'" % id)
       return
   ```
3. 在 `create_character()` 中加重复创建保护：
   ```gdscript
   if have_characters.has(id) and is_instance_valid(have_characters[id]):
       delete_character(id)
   ```
4. 新增 `func create_characters_batch(characters_data: Array)` 供增援系统调用

---

### 任务 3 — 删除 `game/assets/code/character_state_machine_test.gd`

**理由：**
- 该文件只有一行 `extends CharacterBody2D`，是旧状态机方案的测试残留，没有任何功能，留在代码库里会造成混淆。

**具体改动：** 直接删除该文件，或移动到 `back_up/` 目录中存档。

---

### 任务 4 — 修复 `export_presets.cfg`（多个问题）

- [x]（已解决）修改完成

**理由：**
- **版本号过时**：`file_version` 和 `product_version` 均为 `0.1.3.0`，实际版本是 `0.1.6`，导出的 exe 元数据会显示错误版本号。
- **导出路径过时**：Web 和 Windows 导出路径仍指向 `v0.1.3`。
- **产品名称拼写错误**：`application/product_name="CorloredArchive"` 多了一个 `r`，应为 `"ColoredArchive"`。

**具体改动：**
1. 将 `application/file_version` 从 `0.1.3.0` 改为 `0.1.6.0`
2. 将 `application/product_version` 从 `0.1.3.0` 改为 `0.1.6.0`
3. 将 `application/product_name` 从 `"CorloredArchive"` 改为 `"ColoredArchive"`
4. 更新 Web 导出路径：`ColoredArchive_Win_Client_v0.1.3.html` → `v0.1.6.html`
5. 更新 Windows 导出路径：`ColoredArchive_Win_Client_v0.1.3.exe` → `v0.1.6.exe`
6. 或者在 Godot 编辑器中打开 Project Settings → Application → Config → Version 统一修改后重新导出配置

---

---

## P1 — 重要问题

### 任务 5 — 修复 `push_all.bat`

**理由：**
- 当前内容是 `git push all develop`，`git push` 没有 `all` 这个参数，执行会报错。
- 这个脚本是作者的日常推送工具，修好后能减少操作成本。

**具体改动：** 将内容改为 `git push origin develop`

---

### 任务 6 — 处理 `gaming.tscn` 场景丢失问题

**理由：**
- `.godot/editor/` 目录下存在大量 `gaming.tscn-editstate` 和 `gaming.tscn-folding` 编辑器缓存文件，说明作者曾经在 Godot 编辑器中打开过 `gaming.tscn`，但该场景文件在 `assets/scene/` 下不存在。
- 如果是误删，需要从 git 历史中找回；如果已不再需要，需要清理编辑器缓存文件。

**具体改动：**
- 方案 A（确认不再需要）：删除 `.godot/editor/` 下所有 `gaming.tscn-*` 相关文件
- 方案 B（需要恢复）：用 `git log --diff-filter=D -- game/assets/scene/gaming.tscn` 查历史，用 `git checkout` 找回

---

### 任务 7 — 精简 `game/assets/code/main.gd`

**理由：**
- `const Character = preload(...)` 和 `func create_character()` 是旧版直接实例化角色的方式，现在角色由 `character_manager` 管理，这两处代码无人调用，属于死代码。
- `var character_num = 0` 声明后从未被读取，是无效变量。
- `func _on_strategic_deployment_strategic_deployment_is_open()` 是空函数，目前没有任何逻辑，留着只会增加维护负担。

**具体改动：**
- 删除 `const Character`、`var character_num`、`func create_character()`、`func _on_strategic_deployment_strategic_deployment_is_open()`
- 保留 `signal start_a_game`、`var all_map`、`func start_game()`（HUD 的计时器靠 `start_a_game` 信号触发，不可删）

---

### 任务 8 — 修复 `game/assets/code/gaming_camera_2d.gd`

**理由：**
- 第 76 行 `map.get_boundaries()` 的返回值没有被接收或使用，属于无效调用，虽然不会报错但会让代码读者困惑。
- 实际上 limit 已经在下面几行正确赋值，这行完全是多余的。

**具体改动：** 删除第 76 行的 `map.get_boundaries()` 调用。

---

### 任务 9 — 修复 `.gitignore`

**理由：**
- `*.cfg` 规则会忽略 `export_presets.cfg`！这是导出配置，应该入库，否则换电脑开发会丢失导出设置。
- `/addons/` 规则过于激进，会排除 `godot_ai` 和 `godot-git-plugin` 这两个项目正常运行所必需的插件。
- 两条规则都会导致协作时丢失重要文件或引入不必要的文件。

**具体改动：**
```gitignore
# 排除编辑器缓存（只排除 .godot 目录本身）
.godot/
.vscode/
.codebuddy/

# 排除生成文件
*.bak
*.tmp
*.import/

# 排除用户数据
/saves/
/mods/
/log/
/Release/

# 排除旧版代码
/python_old/
back_up/

# 排除推送脚本（内部工具）
push_all.bat

# 显式保留必要文件
!export_presets.cfg
!.gitignore
```

---

## P2 — 战略配备系统

### 任务 10 — 扩展 `game/assets/code/data_manager.gd` 中的战略配备数据

**理由：**
- 当前 `all_strategic_deployment` 每个条目只有 `name`/`cd`/`icon` 三个字段，缺少实现增援逻辑所需的关键数据：消耗多少预算、召唤哪个角色、从什么位置生成。
- 所有图标都指向同一个 `reinforcements.png`，6 个不同配备无法区分。

**具体改动：**
为每个战略配备条目补充以下字段：
```gdscript
"ColoredArchive.reinforcements": {
    "name": "reinforcements",
    "cost": 1000,                          # 新增：消耗的任务预算
    "cd": 160,                             # 冷却时间（秒）
    "icon": "res://assets/images/reinforcements.png",
    "spawn_id": "ColoredArchive.cat",      # 新增：召唤的角色 ID
    "spawn_type": "near_selected",         # 新增：生成方式（near_selected / random_position）
},
```
其他所有条目（resupply、mg-43、fast_resupply、mk-2、L118）都补上相同字段。同时为每个配备制作独立图标，替换统一的 `reinforcements.png`。

---

### 任务 11 — 实现冷却和预算逻辑 `game/assets/code/strategic_deployment.gd`

**理由：**
- 当前 `cost = 30000` 是硬编码值，没有增减机制，玩家无法感知预算变化。
- `cd` 字段存了但没有任何倒计时逻辑，按钮可以随时无限使用。
- 预算显示数值与代码不一致：`tscn` 中硬编码 `"任务预算:3000"`，`gd` 中 `var cost = 30000`，两处对不上。
- 任务预算系统是 GAME_DESIGN.md 中设计的核心经济机制，不实现就无法形成策略深度。

**具体改动：**
1. 将 `cost` 改为动态变量，建议初始值 `var mission_budget := 3000`（与 tscn 中显示值对齐）
2. 新增 `var cooldown_timers := {}` 字典，key 为战略配备 id，value 为剩余冷却秒数
3. 在 `_process` 中每秒递减所有冷却计时器，归零后标记为就绪
4. 新增 `func request_deployment(id: String) -> bool`：
   - 检查预算是否足够
   - 检查冷却是否已结束
   - 满足条件则扣减预算、启动冷却、返回 true
   - 否则返回 false 并输出提示信息
5. 连接按钮的 `pressed` 信号到这个函数

---

### 任务 12 — 实现按钮点击后的增援生成逻辑 `game/assets/code/strategic_deployment_button.gd`

**理由：**
- 当前按钮点击只触发了"选中/取消选中"的动画效果，没有调用任何游戏逻辑，点下去什么都不会发生。
- 玩家选中按钮后不知道下一步该做什么，交互体验断裂。

**具体改动：**
1. 在 `control_button_only_one_can_select()` 中，选中按钮后向父节点（strategic_deployment）发送信号或调用方法，请求执行该战略配备
2. strategic_deployment 收到请求后：
   - 调用 `request_deployment(id)` 检查预算和冷却
   - 通过 `CharacterManager.create_characters_batch()` 生成角色
   - 生成位置根据 `spawn_type` 和 `spawn_offset` 计算（从选中的角色位置偏移）
3. 可选：在按钮上叠加冷却进度条或倒计时显示

---

### 任务 13 — 实现 `strategic_deployment_setting.gd` 或移除无用场景

**理由：**
- `strategic_deployment_setting.gd` 只有一行 `extends Panel`，没有任何逻辑。
- 对应场景 `strategic_deployment_setting.tscn` 在 `main.tscn` 中以 `visible = false` 加载，内部有"reinforcements template"、"resupply template"、"weapon template"等占位节点，但完全无法使用。
- 如果后续要实现战略配备的配置面板，需要实现这个脚本；如果不需要，建议删除该场景及其在主场景中的引用，减少干扰。

**具体改动：**
- 决策：确认是否需要配置面板。
- 如果需要：实现拖拽排序、费用调整等配置功能。
- 如果不需要：从 `main.tscn` 中移除对该场景的引用，删除 `strategic_deployment_setting.tscn` 和空的 `strategic_deployment_setting.gd`。

---

## P3 — 敌人系统

### 任务 14 — 实现 `game/assets/code/enemy.gd`

**理由：**
- 当前 enemy.gd 只有一个 `extends CharacterBody2D`，敌人完全没有行为逻辑。
- 没有敌人，增援系统和战斗系统就没有意义，整个游戏循环无法形成。
- GAME_DESIGN.md 中已定义了护甲等级和穿甲机制，敌人需要有对应的防御属性才能体现这个系统。

**具体改动（最小可行版本）：**
1. 定义属性：HP、速度、护甲等级、攻击伤害、攻击范围
2. 使用 `NavigationAgent2D` 向最近玩家移动
3. 进入攻击范围后停止移动，开始攻击计时，到达时间后造成伤害
4. HP <= 0 时播放死亡效果并 `queue_free()`
5. 在 `data_manager.gd` 中定义敌人类型数据（类似角色的 `all_characters` 字典）

---

### 任务 15 — 在 `character.gd` 里加受击和死亡逻辑

**理由：**
- 当前角色没有 HP 损耗机制，`hp` 属性存了但从不使用。
- 没有死亡状态，角色被击败后仍然在地图上移动，不符合游戏预期。
- `State.DYING` 枚举已预留但无实现。

**具体改动：**
1. 新增 `func take_damage(amount: float)`：
   - 扣除 HP
   - 播放受伤反馈（可选：闪烁贴图）
   - HP <= 0 时调 `transition(State.DYING)`
2. 实现 `_dying_update(_delta)`：
   - 停止移动
   - 播放死亡动画（先占位，后续补充）
   - 动画结束后调 `CharacterManager.delete_character(id)` 销毁自己
3. 通知 character_manager 在角色死亡时做清理（可选：发射信号）

---

## P4 — HUD 完善

### 任务 16 — `game/assets/code/HUD.gd` 显示预算和冷却信息

**理由：**
- 当前 HUD 只显示任务倒计时，玩家看不到任务预算和战略配备冷却状态，信息不完整。
- 战略配备面板和 HUD 是两套独立的 UI，玩家需要在主界面也能看到关键信息。

**具体改动：**
1. 添加预算标签节点引用，绑定到 `strategic_deployment.mission_budget`
2. 在 `_process` 中实时更新预算显示文本
3. 可选：显示选中战略配备的剩余冷却时间

---

### 任务 17 — 精简 `game/assets/code/test_hud.gd`

**理由：**
- `str(int(Engine.get_frames_per_second()))` 中存在冗余的 `int()` 转换，`Engine.get_frames_per_second()` 返回 float，`str()` 会直接转成带小数的字符串，加 `int()` 反而多余且语义不清。

**具体改动：**
```gdscript
# 改前
var FPS = str(int(Engine.get_frames_per_second()))
# 改后
var fps: String = "%d" % Engine.get_frames_per_second()
```

---

## P5 — 整理归档

### 任务 18 — 清理 Python 旧版代码和构建脚本

**理由：**
- `python_old/` 文件夹中的代码基于 Pygame，与当前 Godot 版本完全不兼容，留在根目录会干扰新开发者理解项目结构。
- `python_old/nuitka_build.bat` 和 `python_old/pyinstaller_build.bat` 是旧版打包脚本，已无意义。

**具体改动：**
- 将 `python_old/` 整个目录移入 `back_up/`
- 或直接删除 `python_old/` 及根目录下的构建 `.bat` 文件

---

### 任务 19 — 清理重复备份

**理由：**
- `back_up/` 下存在内容重复的备份：`colored-archive-(4.6)/` 和 `colored_archive_(4.6)/` 是两份不同的 4.6 备份（注意大小写不同），造成了冗余存储。

**具体改动：**
- 比较两份 4.6 备份的差异，保留更新的一份，删除重复的
- 同理处理 4.7 备份（如果存在重复）
- 最终只保留每个版本的最新存档

---

### 任务 20 — 更新 `game/update_log.md`

**理由：**
- 每次完成一批任务后记录更新日志是项目规范，方便追踪版本变更。
- 当前 update_log.md 最后一条记录停留在 2026.09.03，之后没有其他版本记录。

**具体改动：**
- 完成任务后，在 update_log.md 中添加新条目，格式参照已有记录：
  ```
  # vX.Y.Z
  ## YYYY-MM-DD
  ### [添加] ...
  ### [修复] ...
  ### [修改] ...
  ```

---

## 建议执行顺序

```
任务1 → 任务2 → 任务3 → 任务7 → 任务8 → 任务17
                                    ↓
                              验证：角色能正常选中、移动、显示
                                    ↓
任务4 → 任务5 → 任务6 → 任务9（修复致命/重要问题）
                                    ↓
任务10 → 任务11 → 任务12 → 任务13 → 任务16（战略配备可呼出增援）
                                    ↓
                              验证：预算扣除、冷却生效、角色生成
                                    ↓
任务14 → 任务15（敌人出现、战斗形成）
                                    ↓
                              验证：能击杀敌人、角色会受伤死亡
                                    ↓
任务18 → 任务19 → 任务20（清理归档）
```

每完成一个阶段，运行游戏验证后再进入下一个阶段，避免堆积问题。
