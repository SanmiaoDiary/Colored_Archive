---
name: colored-archive-developer-doc
overview: 为 ColoredArchive（彩色档案）Godot 项目编写一份详细的中文开发者文档，覆盖项目结构、架构、核心系统、数据设计、策划数值与扩展指南。
todos:
  - id: explore-verify
    content: 使用 [subagent:code-explorer] 补充核对场景文件、资源目录与配置文件细节，整理文档素材
    status: completed
  - id: write-core
    content: 编写 DEVELOPER.md 项目概览、技术栈、目录结构与系统架构章节
    status: completed
    dependencies:
      - explore-verify
  - id: write-code
    content: 编写 DEVELOPER.md 脚本模块、场景节点树、数据格式与输入映射详解章节
    status: completed
    dependencies:
      - explore-verify
  - id: write-extension
    content: 编写 DEVELOPER.md 策划数值附录、扩展指南与贡献规范章节
    status: completed
    dependencies:
      - explore-verify
  - id: update-log-commit
    content: 更新 game/update_log.md 记录文档新增，执行 git add -A 与 commit
    status: completed
    dependencies:
      - write-core
      - write-code
      - write-extension
---

## 用户需求
用户要求自行阅读项目内容，编写一份详细的开发者文档，帮助开发者理解 ColoredArchive（彩色档案，CA）项目的结构、代码与扩展方式。

## 产品概述
ColoredArchive 是一款使用 Godot 4.7 + GDScript 开发的 2D 像素风 RTT（实时战术）游戏，当前版本 v0.1.6，为《蔚蓝档案》同人作品。项目免费开源、不可用于盈利，游戏内角色与世界观的版权归原版权方所有。

## 文档内容规划
- 文档语言：简体中文；存放位置：项目根目录 `DEVELOPER.md`（与 README.md、updateplan.md 同级）
- 文档应覆盖：项目概览与技术栈、目录结构说明、系统架构与场景节点树、全部脚本模块逐一说明（main / DataManager / character / character_manager / camera / mouse / HUD / map / strategic_deployment 系列 / test_hud / enemy）、数据格式规范（角色字典与战略配备字典的键值结构、id 命名规则"拥有者.名称"）、输入映射表、策划数值附录（护甲等级、穿甲机制、伤害计算、地图 debuff、主线任务类型）、扩展指南（如何新增角色、如何新增战略配备、MOD 说明）、贡献与版本规范
- 文档内容必须与实际代码、场景文件、配置文件逐一对应，不得虚构

## 收尾要求
- 文档编写完成后，按项目惯例更新 `game/update_log.md`（记录新增文档的版本条目），并执行 git add -A 与 git commit

## 技术说明
本任务为纯文档编写任务，不涉及代码或配置改动，无需技术实现方案。文档本身以 Markdown 编写，内容基于对 Godot 4.7 + GDScript 项目代码、场景文件（.tscn）、项目配置（project.godot）、更新日志与策划文档的实际探索结果撰写。

- 编写工具：Markdown（含表格、代码块、Mermaid 节点树图）
- 准确性要求：所有脚本路径、节点路径、字典键名、输入动作名、数值规则均须与代码逐一核对后写入，禁止凭记忆虚构
- 交付物：项目根目录 DEVELOPER.md，以及 game/update_log.md 的版本记录与一次 git commit

## Agent 扩展
### SubAgent
- **code-explorer**
  - 用途：在编写文档前补充核对尚未读取的细节（如 HUD.tscn、strategic_deployment.tscn、main_map.tscn 等场景文件内容、assets/images、assets/styles、assets/languages 等资源目录用途、export_presets.cfg 配置、addons/godot_ai 插件性质），确保文档对项目结构、资源与配置的描述准确完整
  - 预期结果：产出一份核对的目录/文件明细清单，作为 DEVELOPER.md 各章节的编写依据，杜绝文档与代码不符
