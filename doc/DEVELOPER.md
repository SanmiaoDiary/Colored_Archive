# 开发者文档
这是ColoredArchive（以下简称CA）的开发者文档，为想要制作自己的CA版本和MOD提供帮助
# 目录
# 目录
- [项目结构](#项目结构)
- [依赖](#依赖)
- [代码模块](#代码模块)
- [从零开始做一个 CA 模组](#从零开始做一个CA模组)
  - [配置开发环境](#配置开发环境)
  - [创建模组](#创建模组)
  - [为游戏添加新角色](#为游戏添加新角色)
# 项目结构
- doc（文档文件夹）
    - DEVELOPER.md(本文档)
    - example_code.gd(示例代码)
    - GAME_DESIGN.md(游戏设计文档)
- game（游戏开发目录）
    - assets（游戏资产）
        - code（代码）
        - fonts（字体）
        - images（图片）
        - languages（语言文件）
        - musics（音乐）
        - scenes（场景文件）
        - styles（样式文件）    
    - mods（MOD文件夹）
        - example（示例MOD文件夹）
    - saves（存档文件夹）
    - icon.svg（游戏图标文件）
    - icon.svg.import（游戏图标文件）
    - game.godot（项目配置文件）
    - update_log.md(更新日志)
- project_file(工程文件)
    - psds(psd文件)
- python_old（旧版Python代码）
- .gitattributes(git属性文件)
- .gitignore(git忽略文件)
- LICENSE.md(开源许可证文件)
- README.md(README文件)
# 依赖
- Godot 4.7
- GDScript
------
###### （v0.1.3版本以前）
- python
- pygame
# 代码
## character_manager.gd
- 名称：角色管理器
- 功能：管理游戏中的角色
- *次要*
- 成员变量：
  have_characters:dictionary
  现在已经在这局游戏里面的角色的字典
  new_character:object
  存放新角色实例的变量
  character_index:int
  存放角色在自动里面的key的变量
  father_node:Node2D
  角色管理器的父节点
  CHARACTER_SCENE:PackedScene(常量)
  角色场景
  all_characters:dictionary
  所有角色字典
  说明：从data_manager.gd中获取的角色数据
## character_state_machine_test.gd
- 名称：角色状态机测试
- 功能：测试角色状态机
- *次要*
## character.gd
- 名称：角色
- 功能：角色类
- *次要*
## data_manager.gd
- 名称：数据管理器
- 功能：管理CA中所有的数据
- ***重要***
- 成员变量：
  all_characters:dictionary
  所有角色字典
  all_strategic_deployment:dictionary
  所有战略配备字典
## enemy.gd
  敌人  
## gaming_camera_2d.gd
  游戏摄像机2D
## HUD.gd
  战局中ui（抬头显示）
## main.gd
  游戏的主要入口
## map.gd
  地图
## mouse.gd
  鼠标
## strategic_deployment_button.gd
  战略配备按钮
## strategic_deployment_setting.gd
  战略配备设置
## strategic_deployment.gd
  战略配备
## test_hud.gd
  调试ui

# 从零开始做一个CA模组
***！！！注意！！！现在项目处于开发的早期阶段，mod加载器功能暂时没有实现，但是您仍然可以阅读本条目，会对之后的开发有所帮助，当然您也可以基于本条目开发自己的mod加载器***
## 配置开发环境
请确保您的godot版本为4.7.1或更高，且CA可以正常运行
***我不推荐您直接修改CA本体，这样会可能导致您制作的模组与其他开发者制作的不兼容，当然如果您要制作自己的CA版本请忽略此条目直接查看下一条目***
打开GODOT
## 创建模组
在游戏文件夹里面找到mods文件夹
在里面创建一个新的文件夹，文件夹名称为您模组的名称（当然啦您起别的名字也没有关系模组仍然可以正常运行，但是管理模组会比较麻烦）
在文件夹里面创建一个main.gd文件
在里面写入：
```GDScript
extends Node

var mod_id:String = "author.examplemod" # 模组ID命名规范：作者名.模组名
var mod_name:String = "Example Mod" # 模组名称

func _ready():
    # mod启动时要做的事
    pass

func _process():
    # mod运行时要做的事
    pass
```
把里面的mod_id和mod_name替换为您自己的模组id和模组名称
## 为游戏添加新角色
我们在前面的代码模块中说过data_manager.gd这个全局单例是CA用来管理所有的游戏数据的地方，角色的数据就存放在里面
在添加新角色之前我们先来了解一下创建一个角色需要哪些数据呢？请看下面：
```GDscript
"ColoredArchive.cat":{#字典的键就是角色的id，
		"name":"cat",#角色的名字
		"school":"",#角色的所属（可选）
		"speed":150,#角色的移动速度
		"hp":200,#角色的生命值
		"icon":"res://assets/images/cat.png",#角色图标/头像（在角色列表中显示的角色缩略图）
		"texture":"res://assets/images/cat.png",#角色贴图（在游戏中显示的角色主体形象）
		}
```
除了角色的所属（学校）不是必须的其他都是必要的
角色管理器会根据data_manager.gd里面的这个叫做all_characters的字典生成角色，所以你只需要修改这个字典的内容就可以添加新的角色了
举个例子我想要把我的OC添加进去的话就这样写：
```GDscript
DataManager.all_characters[mod_id + ".character_name"]={
    "name":"character_name",
    "school":"character_school",
    "speed":150,
    "hp":200,
    "icon":"角色的图标",
    "texture":"角色的贴图",
}
#记得把这些占位符换成你自己的角色信息和设定哦
```
就是这样是不是很简单？
我们把代码整合起来写一个完整的mod吧
```GDScript
extends Node

var mod_id:String = "SanmiaoDiary.StarAndDream"#模组ID命名规范：作者名.模组名
var mod_name:String = "StarAndDream"#模组名称
var mod_version:String = "0.1"#模组版本

func _ready():
    DataManager.all_characters[mod_id + ".xinmengyao"]={
    "name":"欣梦遥",
    "school":"SRT",
    "speed":150,
    "hp":200,
    "icon":"res://mods/StarAndDream/assets/images/xinmengyao_icon.png",
    "texture":"res://mods/StarAndDream/assets/images/xinmengyao.png",
    }

func _process():
    # mod运行时要做的事
    pass
```
这里有几点需要注意一下：
1. 修改角色字典必须在_ready()函数中进行，如果放在_process()里面的话可能会导致游戏每帧都要添加这个角色，从而导致卡顿
2. 确保你的角色头像和角色贴图的路径都是正确的，不然可能会导致角色头像和角色贴图无法显示。
3. 你的角色头像和贴图应该放置在mods/模组名/assets/images/文件夹下，而不是直接放在游戏的assets/images/文件夹里面，这样会导致其他人游玩你的模组时找不到角色头像和贴图
4. 模组id很重要如果，是模组加载器识别不同模组的根据，写错了可能导致模组无法正常加载
5. 模组版本不是必须的，但是为了版本管理和自己的方便请加上