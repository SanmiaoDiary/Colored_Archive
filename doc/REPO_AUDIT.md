# 仓库审查报告

> 审查日期：2026-08 | 当前版本：v0.1.6

---

## 一、致命问题（会导致运行错误）

### 问题 1 — 场景引用了不存在的脚本
**文件：** `game/assets/scene/mouse_controler.tscn`

**现象：** 场景文件引用了 `mouse_controler.gd`，但该脚本文件在 `assets/code/` 目录下不存在。

**影响：** 打开项目时 Godot 编辑器会报错，场景无法正常加载。

**修复建议：**
- 如果该场景已废弃，从 `main.tscn` 中移除对该场景的引用（实际上 `main.tscn` 没有引用它，是孤立的），直接删除 `mouse_controler.tscn`
- 如果还需要，补写 `mouse_controler.gd`

---

### 问题 2 — `strategic_deployment_setting.gd` 是空脚本
**文件：** `game/assets/code/strategic_deployment_setting.gd`

**现象：** 文件只有一行 `extends Panel`，没有任何逻辑。对应场景 `strategic_deployment_setting.tscn` 在 `main.tscn` 中以 `visible = false` 加载，内部有"reinforcements template"、"resupply template"、"weapon template"等占位节点，但完全无法使用。

**影响：** 战略配备设置面板形同虚设，后续任务 8 需要实现相关逻辑。

**修复建议：** 先搁置，等战略配备系统核心逻辑完成后一并实现。当前可确保该场景不在运行时影响性能（已 hidden）。

---

### 问题 3 — 出口配置版本号与游戏实际版本不一致
**文件：** `game/export_presets.cfg`

| 配置项 | 当前值 | 应为 |
|--------|--------|------|
| Web 导出路径 | `ColoredArchive_Win_Client_v0.1.3.html` | `v0.1.6` |
| Windows 导出路径 | `ColoredArchive_Win_Client_v0.1.3.exe` | `v0.1.6` |
| 发布文件夹 | `Release/0.1.5/web/` / `Release/0.1.6/` | 统一 |
| `application/file_version` | `0.1.3.0` | `0.1.6.0` |
| `application/product_version` | `0.1.3.0` | `0.1.6.0` |

**影响：** 导出的可执行文件元数据版本错误，用户会看到错误的版本号。

**修复建议：** 在 Godot 编辑器中打开 Project Settings → Application → Config → Version，统一改为 `0.1.6`；同时修正 export_presets.cfg 中的导出路径。

---

### 问题 4 — 产品名称拼写错误
**文件：** `game/export_presets.cfg`，第 102 行

```
application/product_name="CorloredArchive"
```

**应为：** `"ColoredArchive"`（多了一个 `r`）

---

## 二、重要问题（影响功能或体验）

### 问题 5 — `push_all.bat` Git 命令错误
**文件：** `push_all.bat`

```bat
git push all develop
```

**问题：** `git push` 没有 `all` 这个参数，正确写法应该是：
```bat
git push origin develop
```
或者如果你想同时推送所有分支：
```bat
git push --all origin
```

---

### 问题 6 — Python 旧版构建脚本仍在根目录
**文件：**
- `push_all.bat`（已修正后）
- `python_old/nuitka_build.bat`
- `python_old/pyinstaller_build.bat`

**问题：** 项目已从 Python/Pygame 迁移到 Godot，但这些批处理文件仍留在根目录，容易误导后来的协作者。

**修复建议：** 将 `python_old/` 整个目录移入 `back_up/`，或删除这些 `.bat` 文件（`.gitignore` 里已有 `/python_old/` 规则，不会上传，但本地看着碍眼）。

---

### 问题 7 — `gaming.tscn` 场景文件丢失
**现象：** `.godot/editor/` 目录下存在大量 `gaming.tscn-editstate` 和 `gaming.tscn-folding` 配置，说明作者在 Godot 编辑器里打开过这个场景，但实际 `assets/scene/` 下没有 `gaming.tscn` 文件。

**影响：** 可能是误删，也可能是从未提交过。如果是误删，需要检查 git 历史找回；如果已不再需要，清理 editor 缓存。

---

### 问题 8 — 所有战略配备图标使用同一张图
**文件：** `game/assets/code/data_manager.gd`

```gdscript
// 所有条目都是：
"icon":"res://assets/images/reinforcements.png"
```

6 个不同的战略配备（reinforcements、resupply、mg-43、fast_resupply、mk-2、L118）共用一张图标，玩家无法区分。

**修复建议：** 为每个战略配备制作独立图标，或至少用不同的颜色 tint 区分。这是美术资源问题，不影响代码运行，但严重影响体验。

---

### 问题 9 — 预算显示数值与代码不一致
**现象：**
- `strategic_deployment.tscn` 中硬编码了 `"任务预算:3000"`
- `strategic_deployment.gd` 中 `var cost = 30000`
- `GAME_DESIGN.md` 中提到预算会因地图 debuff 动态变化

**问题：** 三个地方的数值不一致，且代码中的 `cost` 永远不会改变（没有增减逻辑）。

---

### 问题 10 — Android 导出配置几乎为空
**文件：** `game/export_presets.cfg`，`[preset.2]` 段

- `package/unique_name`：`"com.example.$genname"`（占位符未替换）
- `package/name`：空
- `version/name`：空
- 所有权限均为 `false`（正常，但确认是否需要网络权限用于未来更新检查）

**影响：** 当前不涉及（README 说不上 Steam，移动端也暂未计划），但如果将来要做 Android 版本，这些字段需要先填好。

---

## 三、代码质量小问题

### 问题 11 — `main.gd` 中残留无用代码
**文件：** `game/assets/code/main.gd`

```gdscript
const Character = preload("res://assets/scene/character.tscn")  # 无用
var character_num = 0                                           # 无用
func create_character(): ...                                     # 无用
func _on_strategic_deployment_strategic_deployment_is_open()     # 空函数
```
这些在任务 4 中已列入重构清单。

---

### 问题 12 — `gaming_camera_2d.gd` 第 76 行返回值被丢弃
**文件：** `game/assets/code/gaming_camera_2d.gd`

```gdscript
map.get_boundaries()  # 返回值未使用
```
在任务 5 中已列入修复清单。

---

### 问题 13 — `test_hud.gd` 使用 `str(int(...))` 冗余转换
**文件：** `game/assets/code/test_hud.gd`

```gdscript
var FPS = str(int(Engine.get_frames_per_second()))
```
`Engine.get_frames_per_second()` 返回的就是 float，`int()` 再 `str()` 可以简化为：
```gdscript
var fps := str(Engine.get_frames_per_second())  # 会自动转成整数显示？不，会带小数
# 或者：
var fps := "%d" % Engine.get_frames_per_second()
```

---

## 四、.gitignore 审查

**文件：** `.gitignore`

当前规则基本合理，但有以下注意点：

| 规则 | 状态 | 说明 |
|------|------|------|
| `/addons/` | ⚠️ 过于激进 | 会排除所有 addons，包括 `godot_ai` 和 `godot-git-plugin`。这两个插件是项目正常运行所必需的，应该保留在仓库里。建议改为只忽略 `addons/*/`.import 等生成文件。 |
| `/mods/` | ✅ 合理 | 模组是用户内容，不需要入库 |
| `/saves/` | ✅ 合理 | 存档不应入库 |
| `*.cfg` | ⚠️ 过于激进 | 会忽略 `export_presets.cfg`！这是导出配置，应该入库。建议改为只忽略 `.godot/editor/*.cfg` |
| `back_up/` | ✅ 合理 | 但注意 `back_up/` 下有多个版本的 `export_presets.cfg`，这些也应该被忽略 |

**建议修改 `.gitignore`：**
```gitignore
# 排除编辑器缓存
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

# 保留 export_presets.cfg，只排除编辑器配置
!.gitignore
!export_presets.cfg
```

---

## 五、备份目录冗余

`back_up/` 下有多个版本备份，但存在重复：
- `back_up/colored-archive-(4.6)/` 和 `back_up/colored_archive_(4.6)/` 是两份不同的 4.6 备份（注意大小写不同）
- 同理 `back_up/colored-archive-(4.7)/` 也存在

**建议：** 清理重复备份，只保留最新版本的历史存档即可。

---

## 六、优先级汇总

| 优先级 | 问题编号 | 说明 |
|--------|---------|------|
| 🔴 立即修复 | #1 | mouse_controler.tscn 引用不存在的脚本 |
| 🔴 立即修复 | #4 | 产品名称拼写错误（CorloredArchive） |
| 🟡 尽快修复 | #3 | 导出配置版本号过时 |
| 🟡 尽快修复 | #5 | push_all.bat Git 命令错误 |
| 🟡 尽快修复 | #7 | gaming.tscn 场景丢失（确认是否要恢复） |
| 🟢 后续处理 | #8 | 战略配备图标统一问题 |
| 🟢 后续处理 | #13 | .gitignore 过于激进，排除掉必要文件 |
| 🔵 清理 | #6, #11, #12 | 见重构任务清单 |
