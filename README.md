# ColoredArchive
## 基本信息
[![三苗日记](https://img.shields.io/badge/bilibili-三苗日记-green?labelColor=blue&logo=bilibili&logoColor=white)](https://space.bilibili.com/670231840) [![GitHub 仓库](https://img.shields.io/badge/GitHub-Colored_Archive-181717?logo=github)](https://github.com/SanmiaoDiary/Colored_Archive) [![Gitee 仓库](https://img.shields.io/badge/Gitee-Colored_Archive-C71D23?logo=gitee)](https://gitee.com/sanmiaodiary/colored_archive)
游戏中文名：彩色档案  
游戏英文名：ColoredArchive  
游戏缩写：CA
## 项目介绍
这是一个使用godot&GDscript进行开发的2d像素风RTT游戏
v0.1.3版本前使用python和pygame库进行开发
我们希望把它做成一个蔚蓝档案的同人游戏（当然如果可以的话）  
你可以免费下载并使用它的源代码（进行再次创作或者基于本项目制作属于您的项目），但是您不能把它用于盈利。我们希望大家通过它来获得快乐而不是通过它获得利润  
## 部署项目
注意：从v0.1.3我们使用godot重构了项目，旧的python版本存放在python_older分支（已被废弃不再维护）里，在master和develop分支里面存放在python_old文件夹里面（因为项目的目录结构进行了较大的改变，代码可能无法正常运行）
### godot版本
#### 1. 配置运行环境
首先你应该去[godot官网](https://godotengine.org/zh-cn/)下载4.5或者更高版本的godot编辑器
下载普通版本的即可，如果你下载了C#版本的可能会导致无法运行
#### 2. 下载项目
您可以从代码托管平台上下载此项目
目前我们只在两个平台上上传了此项目
1. [github](https://github.com/SanmiaoDiary/Colored_Archive)
2. [gitee](https://gitee.com/sanmiaodiary/colored_archive)  
   
因为网络原因github仓库可能更新不及时，国内用户推荐使用gitee  
进入仓库的页面  
直接点击克隆/下载按钮  
然后点击下载zip即可  
等待下载完成用解压软件解压   
这里以7zip为例：
3. 找到下载的zip文件  
4. 在当前目录的空白处右键  
5. win10可以直接在弹出的菜单中选择7-zip>提取到[文件名]/下  
win11还要在弹出的菜单里面选择显示更多选项 然后再点击7-zip>提取到[文件名]/下这样就可以解压了
#### 3. 运行项目
解压完成之后打开godot
在弹出的窗口中点击导入按钮选择你刚刚解压好的文件夹里面进入\game文件夹里面就可以找到godot的项目文件了（像这样的：“project.godot”）选择它然后打开
这样项目就会显示在项目管理器里面了双击它打开项目
在弹出的窗口中直接按下F5或者点击右上角的三角形按钮来运行项目
### python版本
如果你希望在您的设备上运行老旧的python版本，请按照以下步骤操作：
#### 1. 配置运行环境
   请确保你的设备上安装了python和pygame库，并确保python的版本为3.13.7及以上如果没有安装python你可以去[python官网](http://python.org)下载python  
   然后根据安装程序安装python  
   按windows+R打开运行程序，输入cmd  
   如果你不知道您的设备上是否安装了python  
   以windows操作系统为例  
   你可以通过这条命令来检查你是否安装了python   
   ```
   python
   ```
   如果出现了Python解释器和版本号，则说明您已经安装python
   如果没有出现说明安装失败，您可能需要重新安装python
   接下来我们来检查您是否安装了pygame
   依旧是在cmd中输入
   ```
   python -m pygame -version
   ```
   如果出现了pygame的版本号，则说明您已经安装pygame  
   如果出现报错则说明您没有安装pygame
   您可以使用这行命令安装pygame
   ```
   pip install pygame
   ```
   安装完成后请按照上面的步骤检查是否安装成功
#### 2. 下载项目
   您可以从代码托管平台上下载此项目
   目前我们只在两个平台上上传了此项目
   1. [github](https://github.com/SanmiaoDiary/Colored_Archive)
   2. [gitee](https://gitee.com/sanmiaodiary/colored_archive)  
   
   因为网络原因github仓库可能更新不及时，国内用户推荐使用gitee  
   进入仓库的页面  
   直接点击克隆/下载按钮  
   然后点击下载zip即可  
   等待下载完成用解压软件解压   
   这里以7zip为例：
   3. 找到下载的zip文件  
   4. 在当前目录的空白处右键  
   5. win10可以直接在弹出的菜单中选择7-zip>提取到[文件名]/下  
   win11还要在弹出的菜单里面选择显示更多选项 然后再点击7-zip>提取到[文件名]/下这样就可以解压了
#### 3. 运行项目
   1. 在您的设备上找到python IDLE或者其他您使用的IDE（集成开发环境）这里以VScode为例请确保您已经安装IDE
   2. 在资源管理器中找到该项目的文件夹并打开这个文件夹，然后这个文件夹的空白处右键  
   windows10系统请在弹出的菜单中选择用VScode打开当前目录   
   windows11系统请在弹出的菜单中选择显示更多选项 然后再点击用VScode打开当前目录这样就可以用VScode打开项目了
   3. 在VScode中打开项目后打开文件夹中名称为main.py的文件这是项目的主程序
   4. 在键盘上按下F5来运行此项目，然后在弹出的菜单中选择  
      > python文件 调试当前正在运行的python文件   
   
      如果出现窗口则说明项目运行成功，如果按照上面的教程没有成功的运行请把问题提交到Issues或者联系我们
## 使用的第三方资产
如有侵权，请联系删除
| 资产名称          | 资产类型 | 资产作者    | 资产来源 |
|-------------------|----------|-------------|----------|
| Minecraft AE.ttf  | 字体     | 未知        | 网络     |
| Constant Moderato | 音乐     | TIHA Studio | 网络     |
## 常见问题回答
### 1. 手机可以玩吗？会有手机版吗？
>可以，一定要用手机的话可以用模拟器或者转译运行。以后可能会有手机版。现在主要是实现最基本的玩法，暂时不考虑兼容手机等移动端
### 2. 游戏会上架steam吗？
>不会，因为版权限制和其他各种各样的问题本游戏永远不会上架steam
## 声明
本项目免费完全开源免费，游戏内角色和世界观设定版权属于韩国NEXON公司和上海星啸网络科技有限公司所有，仅保留著作权