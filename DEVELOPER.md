# ColoredArchive 开发者文档（面向二创作者 / MOD 开发者）

## 目录

- [1. 本文档是什么](#1-本文档是什么)
- [2. 版权与二创许可](#2-版权与二创许可)
- [3. 快速上手](#3-快速上手)
- [4. 游戏机制与数值说明](#4-游戏机制与数值说明)
- [5. 内容扩展指南](#5-内容扩展指南)
- [6. 素材制作规范](#6-素材制作规范)
- [7. MOD 开发指南](#7-mod-开发指南)
- [8. 常见问题](#8-常见问题)
- [附录 A：输入映射表](#附录-a输入映射表)
- [附录 B：常用路径速查](#附录-b常用路径速查)

---

## 1. 本文档是什么

**ColoredArchive（彩色档案，简称 CA）** 是一款使用 Godot（GDScript）开发的 2D 像素风 RTT（实时战术）同人游戏，致敬《蔚蓝档案（Blue Archive）》。

本项目的核心开发者只有一人，因此本文档**不是**给核心开发看的内部实现说明，而是写给所有**二创作者和 MOD 开发者**的创作指南。本文档回答三个问题：

1. 我可以在什么范围内自由创作？（版权与二创许可）
2. 这个游戏有哪些机制与数值，我该遵循什么？（游戏设计）
3. 我如何向游戏里加入新角色、新战略配备、新地图甚至整个 MOD？（扩展指南）

> 阅读前提：你不需要会写代码也能看懂大部分内容（第 5、7 章有少量 GDScript/JSON 示例，按图索骥复制修改即可）。

### 1.1 项目技术栈

| 项目 | 说明 |
|------|------|
| 游戏引擎 | Godot 4.5 或更高版本（当前开发使用 4.7.x，标准版即可，**不要**用 C# 版） |
| 脚本语言 | GDScript |
| 渲染 | 2D，`Mobile` 渲染模式 |
| 分辨率 | 1920 × 1200 |
| 主目录 | `game/`（Godot 项目根目录） |
| 当前版本 | v0.1.x（开发分支 develop） |

### 1.2 一句话认识项目结构

```
ColoredArchive/
├── game/                  # Godot 项目（一切创作都在这里发生）
│   ├── project.godot      # 项目配置（自动加载、输入映射、窗口等）
│   ├── assets/
│   │   ├── code/          # 所有 GDScript 脚本
│   │   ├── scene/         # 所有场景（.tscn）
│   │   ├── images/        # 图片素材
│   │   ├── fonts/         # 字体
│   │   ├── musics/        # 音乐
│   │   ├── languages/     # 语言文件（zh_cn.json / en.json）
│   │   └── styles/        # 主题样式（.tres）
│   └── mods/              # MOD 目录（见第 7 章）
├── python_old/            # 废弃的 pygame 旧版（不要使用）
└── DEVELOPER.md           # 本文档
```

---

## 2. 版权与二创许可

### 2.1 一句话声明

> 本项目**免费、完全开源、不可盈利**。游戏内角色与世界观设定版权归韩国 **NEXON** 公司和 **上海星啸网络科技有限公司** 所有，本项目仅保留著作权。

### 2.2 你可以做什么

- ✅ 免费下载、修改、再分发本项目源码
- ✅ 基于本项目制作你自己的项目（换皮、加内容、做 MOD 均可）
- ✅ 自由创作非商业性的同人内容（视频、直播、图片等）
- ✅ 使用本项目素材制作二创，只要不用于盈利

### 2.3 你不可以做什么

- ❌ 将本项目或基于本项目的内容**用于盈利**（含收费下载、广告分成、上架 Steam 等）
- ❌ 将《蔚蓝档案》角色与世界观设定据为己有、用于商业用途
- ❌ 冒充官方或原版发行方

### 2.4 第三方资产来源

本项目使用了以下第三方资产（如侵权请联系删除）：

| 资产名称 | 类型 | 作者 | 来源 |
|---------|------|------|------|
| Minecraft AE(支持中文).ttf | 字体 | 未知 | 网络 |
| [蔚蓝档案交响乐]Constant Moderato.mp3 | 音乐 | TIHA Studio | 网络 |

**素材引用提醒**：如果你在自己发布的 MOD 或项目里继续使用这些第三方资产，请保留署名；最好附上来源链接。

---

## 3. 快速上手

### 3.1 运行项目

1. 从 [Godot 官网](https://godotengine.org/zh-cn/) 下载 **4.5 或更高版本** 的**标准版**（非 .NET/C# 版）。
2. 下载项目源码（GitHub: `SanmiaoDiary/Colored_Archive`，Gitee: `sanmiaodiary/colored_archive`，国内推荐 Gitee）。
3. 打开 Godot → 导入 → 选择 `game/project.godot`。
4. 打开项目后按 `F5`（或右上角 ▶）运行。

### 3.2 第一课：改哪里能看到效果

如果你是第一次接触这个项目，按下面的顺序试，每一步都能立刻看到变化：

1. **改角色数据**：打开 `game/assets/code/data_manager.gd`，把 `all_characters` 里 `ColoredArchive.cat` 的 `"speed":150` 改成 `300`，运行后你的猫会跑得飞快。
2. **改角色长什么样**：把 `"texture":"res://assets/images/cat.png"` 指向你自己的图片路径，把图片放进 `game/assets/images/` 即可。
3. **加一个新的战略配备**：在 `data_manager.gd` 的 `all_strategic_deployment` 里复制一段，换一个键名（如 `"ColoredArchive.my_airdrop"`）和 `name`/`cd`，运行后按 `Tab` 打开战略配备面板就能看到新按钮。
4. **改任务预算**：打开 `game/assets/code/strategic_deployment.gd`，把 `cost = 30000` 改小，感受一下资源紧张。

> 记住：**所有角色和战略配备的数据都集中在 `data_manager.gd` 这一个文件里**，它是本项目的"数据字典"，也是你扩展内容的第一站。

### 3.3 自动加载（Autoload）

`project.godot` 中注册了两个全局单例，任何脚本都能直接调用：

| 单例 | 脚本 | 作用 |
|------|------|------|
| `DataManager` | `game/assets/code/data_manager.gd` | 所有角色 / 战略配备的数据字典 |
| `Mouse` | `game/assets/code/mouse.gd` | 全局鼠标样式控制（如 `Mouse.mouse_can_click()`） |

---

## 4. 游戏机制与数值说明

> 本节内容基于 `updateplan.md` 的策划方案。部分数值仍在打磨中，以实际版本为准。

### 4.1 生命值：HP 与结构值双体系

单位拥有两套"生命"概念：

| 体系 | 含义 | 特点 |
|------|------|------|
| **HP（生命值）** | 单位的常规血量 | 被打掉后单位仍可能以受损状态存在 |
| **结构值** | 单位的骨架/装甲结构完整性 | 结构值归零则单位彻底被摧毁 |

- 普通攻击主要削减 **HP**，对结构值影响有限。
- 爆炸类 / 高穿甲攻击会同时威胁 **结构值**。
- 设计上鼓励：轻火力压制"打伤"，重火力"拆解"。

### 4.2 护甲与穿甲

**护甲等级范围：0 ~ 12**。

穿甲判定基于 `护甲 - 穿甲` 的差值：

| 护甲 − 穿甲 | 判定结果 |
|-------------|----------|
| ≥ 3 | 几乎完全免疫：仅造成 1 点结构伤害 |
| = 2 | 伤害被大幅削弱：结构伤害 −50%，且该 50% 转为结构伤害 |
| = 1 | 结构伤害 −25%，剩余 25% 转为结构伤害 |
| = 0 | 伤害保持不变 |
| ≤ −1 ~ ≤ −6 | 越打越疼：爆炸伤害依次降低 10% ~ 60%，但结构伤害依次增加 50% ~ 800% |

**策划理解**：穿甲的意义是"有效瓦解装甲单位"；反过来，对无甲目标使用高穿甲武器反而会损失爆炸威力——所以选择合适的武器打合适的敌人很重要。

### 4.3 任务与关卡

**任务预算**：每场战斗有固定的任务预算（当前默认 `30000`），战略配备等资源消耗都会占用预算（见 `strategic_deployment.gd` 的 `cost`）。

**主线任务类型**（按策划案）：

| 任务类型 | 目标 |
|----------|------|
| 闪击战 | 在限定时间内快速击溃敌人 |
| 歼灭战 | 消灭全部敌军 |
| 保卫战 | 保护友方目标不被摧毁 |
| 发射航空火箭 | 护送/推进我方发射装置并完成发射 |
| 运输物资 | 在指定路线上运送物资 |

**地图负面效果（Debuff）**：部分地图自带挑战性负面效果：

| Debuff | 效果 |
|--------|------|
| 更远机场 / 直升机场 | 增援抵达时间变长 |
| 复杂电磁环境 | 部分电子类战略配备受影响 |
| 沙尘暴 | 视野受限 |
| 紧张任务预算 | 本关任务预算低于默认值 |

### 4.4 角色基础属性（数据字典字段）

每个角色在 `data_manager.gd` 的 `all_characters` 中注册，字段如下：

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | String | 显示名称 |
| `school` | String | 所属学院（如 `ABYDOS`），可为空 |
| `speed` | int | 移动速度（NavigationAgent2D 的最大速度） |
| `hp` | int | 生命值 |
| `icon` | String | 角色头像图标（资源路径字符串） |
| `texture` | String | 角色主体贴图（资源路径字符串） |

> **重要**：`icon` 与 `texture` 存的是 **`res://` 路径字符串**（如 `"res://assets/images/cat.png"`），不是 `preload()` 结果。脚本里通过 `load()` 加载（见 `character.gd`）。

---

## 5. 内容扩展指南

### 5.1 新增一个角色

**第 1 步：准备素材**（没有素材也能先跑通）

把角色贴图（透明背景 PNG）放入 `game/assets/images/`，例如 `my_unit.png`。

**第 2 步：在数据字典注册**

编辑 `game/assets/code/data_manager.gd` 的 `all_characters`，在末尾追加：

```gdscript
"ColoredArchive.MyUnit":{
    "name":"MyUnit",
    "school":"ABYDOS",
    "speed":160,
    "hp":260,
    "icon":"res://assets/images/my_unit.png",
    "texture":"res://assets/images/my_unit.png",
},
```

**第 3 步：在代码里创建角色**

打开 `game/assets/code/character_manager.gd`，在 `_ready()` 里调用：

```gdscript
create_character("ColoredArchive.MyUnit", Vector2(683.0, 502.0), Vector2(1.0, 1.0))
```

`create_character(id, position, scale)` 会：

1. 从 `DataManager.all_characters` 取出 `speed` / `hp` / `texture`；
2. 实例化 `res://assets/scene/character.tscn`；
3. 调用 `setup(...)` 注入参数，并加入场景树；
4. 存入 `have_characters[id]` 字典方便管理。

**第 4 步：确认导航**

`character_manager.gd` 顶部有一个导出变量：

```gdscript
@export var navigation_region2D: NavigationRegion2D
```

需要在编辑器里选中 `CharacterManager` 节点，在检查器中把 `navigation_region2D` 指向场景里的 `NavigationRegion2D`（例如 `map/NavigationRegion2D`）。否则角色无法寻路。

**字段约定**：

- `键` 的格式是 `拥有者.角色名`，如 `ColoredArchive.cat`。原版角色统一用 `ColoredArchive.` 前缀，MOD 角色用你自己的 MOD 名作前缀（见第 7 章）。
- 键名全局唯一，不能与其他角色重复。

### 5.2 新增一个战略配备

**第 1 步：准备图标**（可选，未提供则沿用现有图标）

图标放入 `game/assets/images/`，例如 `my_airdrop.png`。

**第 2 步：在数据字典注册**

编辑 `data_manager.gd` 的 `all_strategic_deployment`：

```gdscript
"ColoredArchive.my_airdrop":{
    "name":"my_airdrop",
    "cd":120,
    "icon":"res://assets/images/my_airdrop.png"
},
```

**第 3 步：无需改按钮代码**

`strategic_deployment_button.gd` 的 `create_button()` 会自动遍历 `DataManager.all_strategic_deployment`，为每一条数据生成一个按钮（64×64，纵向排列在战略配备面板左侧）。运行后按 `Tab` 即可看到新按钮。

**字段约定**：

| 字段 | 说明 |
|------|------|
| `name` | 战略配备显示名 |
| `cd` | 冷却时间（秒），如 `90` / `160` |
| `icon` | 按钮图标路径字符串（`load()` 加载） |

**注意**：目前按钮只有"选中/取消选中"的表现层功能，具体效果（呼叫增援、补给等）尚未实现，选中的按钮暂时不会真的触发效果——这是当前版本的已知状态，欢迎一起完善。

### 5.3 新增一张地图

地图系统当前以瓦片地图（`TileMapLayer`）实现，脚本在 `game/assets/code/map.gd`：

- `map.gd` 提供 `get_boundaries()` 方法，根据瓦片尺寸与使用区域计算地图边界，供相机限位使用。
- 主场景（`main.gd`）里有 `all_map = ["grass"]` 数组，任务开始时会随机选一张地图。

**扩展地图的步骤（建议流程）**：

1. 复制现有地图场景（如 `main_map.tscn`）或新建 `TileMapLayer`；
2. 用瓦片集铺好地形，确认瓦片尺寸与 `map.gd` 计算逻辑匹配；
3. 配置 `NavigationRegion2D` 的可行走区域（角色寻路依赖它）；
4. 在地图数据源里登记新地图的 id 与加载路径。

> 地图模块仍在早期阶段，如果你希望做新地图，建议先在 Issue 里与作者交流一次格式约定，避免返工。

### 5.4 多语言（i18n）

- 语言文件位于 `game/assets/languages/`：`zh_cn.json`（简体中文）、`en.json`（英文）。
- 文件结构采用 JSON 键值对形式（键名 + 翻译文本）。
- 当前语言文件仍为空（多语言系统尚未启用），但约定已固定：**新增任何 UI 文本时，同步在两个 json 中登记相同键名**。
- 示例（规划格式）：

```json
{
  "task_budget": "任务预算"
}
```

### 5.5 修改游戏设置

| 想改什么 | 去哪改 |
|----------|--------|
| 窗口分辨率 | `game/project.godot` → `[display]` 区（当前 1920×1200） |
| 输入按键 | `game/project.godot` → `[input]` 区（见附录 A） |
| 最大帧率 / 垂直同步 | 编辑器右侧项目设置，运行中立即生效 |
| 任务预算 | `strategic_deployment.gd` 的 `cost = 30000` |
| 任务倒计时 | `main.gd` 的 `mission_countdown` |

---

## 6. 素材制作规范

### 6.1 总体风格

本项目为 **2D 像素风**。请保持以下原则：

- 使用**透明背景 PNG** 作为角色/图标贴图（JPG 无透明通道，只适合地图等全幅贴图）。
- 像素风角色建议在 `32×32` 左右的网格内绘制，放大后保持清晰锐利（关闭平滑）。
- 素材尺寸尽量取 2 的幂或 8 的倍数，便于缩放与对齐。
- 字体 / 音乐等资源放入后，Godot 会自动生成 `.import` 文件，**不要手动编辑或删除 `.import` 文件**。

### 6.2 各类素材规格

| 素材类型 | 推荐规格 | 参考现有资源 |
|----------|----------|--------------|
| 角色贴图（texture） | 透明 PNG，像素风 | `images/cat.png` |
| 角色头像（icon） | 同贴图或正方形缩略图 | `images/cat.png` |
| 战略配备按钮图标 | 64×64 正方形 | `images/reinforcements.png` |
| 地图瓦片 | 正方形瓦片（如 32×32 / 64×64） | `images/grass_green.png`、`grass_yellow.png` |
| 鼠标指针（普通） | 32×32；4K 大屏用 64×64 | `images/mouse_32x32.png`、`mouse_64x64.png` |
| 鼠标指针（可点击态） | 同上，单独一套 | `images/mouse_selectable_32x32.png` 等 |
| 选中标记 | 透明 PNG 环形/矩形框 | `images/character_selection_marker.png` |
| 字体 | 需支持中文 | `fonts/Minecraft AE(支持中文).ttf` |
| 音乐 | OGG 或 MP3 | `musics/[蔚蓝档案交响乐]Constant Moderato.mp3` |

### 6.3 命名规范

- 使用**小写字母 + 下划线**命名文件：`my_airdrop.png`，不要用空格、中文名或大写开头。
- 路径全部使用 `res://` 相对路径写入数据字典。
- 同一素材不要重复存放，统一放 `game/assets/images/`。

### 6.4 鼠标样式机制

- `Mouse` 单例负责全局鼠标切换。
- 当鼠标悬停在可点击对象（角色、按钮）上时，调用 `Mouse.mouse_can_click()` 切换为可点击指针；离开时调用 `Mouse.mouse_can_not_click()`。
- 如果你做新按钮/新角色，记得在 `mouse_entered` / `mouse_exited` 里连接这两个方法（参考 `strategic_deployment_button.gd` 与 `character.gd`）。

---

## 7. MOD 开发指南

### 7.1 现状（如实说明）

> **目前 MOD 加载机制尚未实现。** `game/mods/example_mod/example_mod.py` 是早期 pygame 时代遗留的 Python 占位示例（`import pygame`，无实际功能），它**不代表**未来 Godot 版 MOD 的形态。也就是说：今天你写一个 MOD 文件夹进去，游戏还不会自动加载它。

因此，本章内容是**规划中的 MOD 规范与约定**，欢迎你提前按这个格式组织内容。等加载器落地后，这些规范将直接生效；你也完全可以在 Issue 里对规范提建议。

### 7.2 未来 MOD 目录结构（规划约定）

```
game/mods/
└── my_mod/                  # 每个 MOD 一个文件夹，文件夹名 = MOD 唯一 id
    ├── manifest.json        # MOD 清单（必填）
    ├── mod.gd               # MOD 入口脚本（可选，需要逻辑时）
    ├── assets/              # MOD 自带素材
    │   └── images/
    └── data/                # MOD 数据（可选，用于声明式注册内容）
```

### 7.3 manifest.json（规划格式）

```json
{
  "id": "my_mod",
  "name": "我的模组",
  "version": "0.1.0",
  "author": "你的名字",
  "description": "简单描述这个 MOD 做什么",
  "requires": {
    "godot": ">=4.5"
  }
}
```

字段说明：

| 字段 | 必填 | 说明 |
|------|------|------|
| `id` | ✅ | 全局唯一，与文件夹名一致；同时作为数据字典键的前缀 |
| `name` | ✅ | 玩家可见的 MOD 名 |
| `version` | ✅ | 建议语义化版本 `主.次.修订` |
| `author` | 建议 | 署名 |
| `description` | 建议 | 一句话介绍 |
| `requires` | 可选 | 引擎版本等依赖要求 |

### 7.4 数据注册约定（规划）

MOD 内容通过"**前缀 + 注册**"接入现有数据字典：

1. 所有键使用 `你的MOD的id.内容名` 格式，例如 `my_mod.shiroko_swimsuit`，避免与 `ColoredArchive.` 原版内容或其他 MOD 冲突。
2. 计划提供 `mod_register()` 钩子（在入口脚本 `mod.gd` 中实现），加载器按序调用：
   - `mod_register_data()`：把角色/战略配备条目合并进 `DataManager.all_characters` / `all_strategic_deployment`；
   - `mod_ready()`：加载完成后执行初始化逻辑。
3. 同一钩子内，MOD 可以注册新角色、新战略配备、新地图与新 UI 文本键。

**规划中的钩子签名示例**：

```gdscript
extends Node

## 注册本 MOD 的数据（在 DataManager 加载后调用）
func mod_register_data() -> void:
    DataManager.all_characters["my_mod.hero"] = {
        "name": "Hero",
        "school": "",
        "speed": 170,
        "hp": 300,
        "icon": "res://mods/my_mod/assets/images/hero.png",
        "texture": "res://mods/my_mod/assets/images/hero.png",
    }

## MOD 初始化（数据注册完成后调用）
func mod_ready() -> void:
    print("my_mod loaded")
```

### 7.5 现在就能做的准备工作

即使加载器还没实现，你现在就可以：

1. 在 `game/mods/` 下新建你的 MOD 文件夹，按 7.2 的结构放好 `manifest.json` 和素材；
2. 把角色/战略配备条目用**你的 MOD 前缀**写进数据字典（5.1 / 5.2 的方法），验证数据字段正确；
3. 等加载器发布后，把条目从 `data_manager.gd` 迁移到你的 MOD 数据文件即可，无需改格式。

### 7.6 示例 MOD 说明

`game/mods/example_mod/example_mod.py` 当前内容只是 pygame 时代的占位符（`import pygame` + 注释），**没有实际功能**。未来的示例 MOD 将替换为符合 7.2~7.4 规范的 Godot 版本。你可以复制它作为自己 MOD 文件夹的模板雏形。

---

## 8. 常见问题

### 8.1 我改了 `data_manager.gd` 没生效？

- 检查语法：花括号、逗号是否配对（字典每一项以 `,` 结尾）。
- 检查键名是否重复（重复的键会被覆盖）。
- 检查资源路径：`res://` 开头的路径必须真实存在，`.import` 文件未被误删。
- 在 Godot 编辑器里运行（`F5`），看底部「输出」面板是否有报错。

### 8.2 角色创建了但不会动？

大概率是 `navigation_region2D` 没在检查器里指定，或 `NavigationRegion2D` 没有烘焙可行走区域。参考 [5.1 第 4 步](#第-4-步确认导航)。

### 8.3 角色贴图不显示 / 白块？

- 确认 `texture` 指向的图片路径正确。
- 角色贴图用 PNG（透明背景），JPG 没有透明通道。

### 8.4 我能用游戏里的素材做自己的视频/图片吗？

可以，前提是**不用于盈利**，且注意第 2 章的版权边界（角色设定版权归 NEXON / 上海星啸）。

### 8.5 我想反馈 bug 或提建议？

- 在 GitHub / Gitee 仓库提交 Issue（注明游戏版本号、复现步骤）。
- 联系作者（B 站：三苗日记）。

### 8.6 旧版 pygame 代码还能用吗？

`python_old/` 是废弃版本（v0.1.3 之前的开发方式），目录结构已大改，**无法正常运行**，请勿使用。

---

## 附录 A：输入映射表

定义于 `game/project.godot` → `[input]`。

| 动作名 | 默认按键 | 用途 |
|--------|----------|------|
| `w_down` | W | 视角上移 |
| `a_down` | A | 视角左移 |
| `s_down` | S | 视角下移 |
| `d_down` | D | 视角右移 |
| `mouse_left_down` | 鼠标左键 | 选中角色 / 框选 / 下达移动指令 |
| `mouse_right_down` | 鼠标右键 | （预留） |
| `Tab_down` | Tab | 开关战略配备面板 |
| `Esc_down` | Esc | （预留）退出 / 菜单 |
| `zoom_in` | 滚轮上 | 视角放大 |
| `zoom_out` | 滚轮下 | 视角缩小 |
| `F3_down` | F3 | 调试 HUD 开关 |
| `" "`（空格） | 无 | 空输入，预留 |

---

## 附录 B：常用路径速查

| 用途 | 路径 |
|------|------|
| 角色 & 战略配备数据字典 | `game/assets/code/data_manager.gd` |
| 角色创建逻辑 | `game/assets/code/character_manager.gd` |
| 角色行为（状态机/移动/选中） | `game/assets/code/character.gd` |
| 战略配备面板 | `game/assets/code/strategic_deployment.gd` |
| 战略配备按钮生成 | `game/assets/code/strategic_deployment_button.gd` |
| 主流程（地图选择/任务倒计时） | `game/assets/code/main.gd` |
| 地图边界计算 | `game/assets/code/map.gd` |
| 项目配置（输入/窗口/autoload） | `game/project.godot` |
| 角色场景 | `game/assets/scene/character.tscn` |
| 图片素材 | `game/assets/images/` |
| 语言文件 | `game/assets/languages/zh_cn.json`、`en.json` |
| 更新日志 | `game/update_log.md` |
| 策划案 | `updateplan.md` |

---

*文档维护：每次大版本更新会同步修订本文档。如有出入以 `game/` 内实际代码与 `updateplan.md` 为准。*
