# ColoredArchive 重构任务清单

> 本文件记录项目当前需要完成的改造任务，按优先级排列。
> 作者：SanmiaoDiary | 更新日期：2026-08

---

## P0 — 角色系统重构（影响最大，先做）

### 任务 1 — 重写 `game/assets/code/character.gd`

**理由：**
- 当前代码使用字典存储状态（`{"selection": false, "action": "", "move": false}`），`selection` 和 `action` 字段从未被使用，逻辑分散在多处难以维护。
- `_process` 中调用 `move_and_slide()` 是错误做法，移动逻辑必须在 `_physics_process` 物理帧中执行。
- `all_characters` 变量在每个角色实例中都存了一份副本，但从不使用，浪费内存。
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
1. 将 `_ready()` 开头的清场循环提取为独立函数 `func clear_all_characters()`，保留代码供热加载调用，同时在 `_ready()` 中也调用一次（让注释说明用途）：
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

### 任务 3 — 删除或归档 `game/assets/code/character_state_machine_test.gd`

**理由：**
- 该文件只有一行 `extends CharacterBody2D`，是旧状态机方案的测试残留，没有任何功能，留在代码库里会造成混淆。
- 保留它会让人误以为这是正式代码的一部分。

**具体改动：**
- 直接删除该文件，或移动到 `back_up/` 目录中存档。

---

## P1 — 清理死代码

### 任务 4 — 精简 `game/assets/code/main.gd`

**理由：**
- `const Character = preload(...)` 和 `func create_character()` 是旧版直接实例化角色的方式，现在角色由 `character_manager` 管理，这两处代码无人调用，属于死代码。
- `var character_num = 0` 声明后从未被读取，是无效变量。
- `func _on_strategic_deployment_strategic_deployment_is_open()` 是空函数，目前没有任何逻辑，留着只会增加维护负担。

**具体改动：**
- 删除 `const Character`、`var character_num`、`func create_character()`、`func _on_strategic_deployment_strategic_deployment_is_open()`
- 保留 `signal start_a_game`、`var all_map`、`func start_game()`（HUD 的计时器靠 `start_a_game` 信号触发，不可删）

---

### 任务 5 — 修复 `game/assets/code/gaming_camera_2d.gd`

**理由：**
- 第 76 行 `map.get_boundaries()` 的返回值没有被接收或使用，属于无效调用，虽然不会报错但会让代码读者困惑。
- 实际上 limit 已经在下面几行正确赋值，这行完全是多余的。

**具体改动：**
- 删除第 76 行的 `map.get_boundaries()` 调用（或其结果接收变量），或在注释中说明其用途。

---

## P2 — 战略配备系统（让按钮真正生效）

### 任务 6 — 扩展 `game/assets/code/data_manager.gd` 中的战略配备数据

**理由：**
- 当前 `all_strategic_deployment` 每个条目只有 `name`/`cd`/`icon` 三个字段，缺少实现增援逻辑所需的关键数据：消耗多少预算、召唤哪个角色、从什么位置生成。
- 所有图标都指向同一个 `reinforcements.png`，说明图标资源还没细化，但这不影响功能实现。

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
其他所有条目（resupply、mg-43、fast_resupply 等）都补上相同字段。

---

### 任务 7 — 实现冷却和预算逻辑 `game/assets/code/strategic_deployment.gd`

**理由：**
- 当前 `cost = 30000` 是硬编码值，没有增减机制，玩家无法感知预算变化。
- `cd` 字段存了但没有任何倒计时逻辑，按钮可以随时无限使用。
- 任务预算系统是 GAME_DESIGN.md 中设计的核心经济机制，不实现就无法形成策略深度。

**具体改动：**
1. 将 `cost` 改为动态变量，添加 `var mission_budget := 3000`（建议从 30000 降到合理值）
2. 新增 `var cooldown_timers := {}` 字典，key 为战略配备 id，value 为剩余冷却秒数
3. 在 `_process` 中每秒递减所有冷却计时器，归零后标记为就绪
4. 新增 `func request_deployment(id: String) -> bool`：
   - 检查预算是否足够
   - 检查冷却是否已结束
   - 满足条件则扣减预算、启动冷却、返回 true
   - 否则返回 false 并输出提示信息
5. 连接按钮的 `pressed` 信号到这个函数

---

### 任务 8 — 实现按钮点击后的增援生成逻辑 `game/assets/code/strategic_deployment_button.gd`

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

## P3 — 敌人系统

### 任务 9 — 实现 `game/assets/code/enemy.gd`

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

### 任务 10 — 在 `character.gd` 里加受击和死亡逻辑

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

### 任务 11 — `game/assets/code/HUD.gd` 显示预算和冷却信息

**理由：**
- 当前 HUD 只显示任务倒计时，玩家看不到任务预算和战略配备冷却状态，信息不完整。
- 战略配备面板和 HUD 是两套独立的 UI，玩家需要在主界面也能看到关键信息。

**具体改动：**
1. 添加预算标签节点引用，绑定到 `strategic_deployment.mission_budget`
2. 在 `_process` 中实时更新预算显示文本
3. 可选：显示选中战略配备的剩余冷却时间
4. 可选：角色血条显示（目前角色头上有血条，但 HUD 中没有汇总信息）

---

## P5 — 整理归档

### 任务 12 — 清理 Python 旧版代码

**理由：**
- `python_old/` 文件夹中的代码基于 Pygame，与当前 Godot 版本完全不兼容，留在根目录会干扰新开发者理解项目结构。
- README 已说明旧版本存放在 `python_older` 分支，`python_old/` 可以视为废弃内容。

**具体改动：**
- 将 `python_old/` 移入 `back_up/` 目录
- 或在 `.gitignore` 中排除该目录并添加注释说明

---

### 任务 13 — 更新 `game/update_log.md`

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
任务1 → 任务2 → 任务3 → 任务4 → 任务5
                                    ↓
                              验证：角色能正常选中、移动、显示
                                    ↓
任务6 → 任务7 → 任务8 → 任务11（战略配备可呼出增援）
                                    ↓
                              验证：预算扣除、冷却生效、角色生成
                                    ↓
任务9 → 任务10（敌人出现、战斗形成）
                                    ↓
                              验证：能击杀敌人、角色会受伤死亡
                                    ↓
任务12 → 任务13（清理归档）
```

每完成一个阶段，运行游戏验证后再进入下一个阶段，避免堆积问题。
