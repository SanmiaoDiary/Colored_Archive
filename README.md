# ColordeArchive
## 基本信息
游戏中文名：彩色档案  
游戏英文名：ColordeArchive  
游戏缩写：CA(我们希望您这么称呼它，当然你想叫它别的名字也没关系)
## 项目介绍
这是一个基于python的游戏，使用pygame库进行游戏开发的2d像素风RTT（实时战术游戏）  
我们希望把它做成一个蔚蓝档案的同人游戏（当然如果可以的话）  
你可以免费下载并使用它的源代码，但是你不能把它用于盈利。我们希望大家通过它来获得快乐而不是通过它获得利润  
游戏使用的字体——Minecraft AE 来源于网络
## 部署项目
如果你希望在您的设备上运行这个项目，请按照以下步骤操作：
1. ### 配置运行环境
   请确保你的设备上安装了python和pygame库，并确保python的版本为3.13.7及以上如果没有安装python你可以去[python官网](http://python.org"python官网")下载python  
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
2. ### 下载项目
   您可以从代码托管平台上下载此项目
   目前我们只在两个平台上上传了此项目
   1. [github](https://github.com/SanmiaoDiary/Colored_Archive"github")
   2. [gitee](https://gitee.com/sanmiaodiary/colored_archive"gitee")  
   
   因为网络原因github仓库可能更新不及时，国内用户推荐使用gitee  
   进入仓库的页面  
   直接点击克隆/下载按钮  
   然后点击下载zip即可  
   等待下载完成用解压软件解压   
   这里以7zip为例：
   1. 找到下载的zip文件  
   2. 在当前目录的空白处右键  
   3. win10可以直接在弹出的菜单中选择7-zip>提取到[文件名]/下  
   win11还要在弹出的菜单里面选择显示更多选项 然后再点击7-zip>提取到[文件名]/下这样就可以解压了
3. ### 运行项目
   1. 在您的设备上找到python IDLE或者其他您使用的IDE（集成开发环境）这里以VScode为例请确保您已经安装IDE
   2. 在资源管理器中找到该项目的文件夹并打开这个文件夹，然后这个文件夹的空白处右键  
   windows10系统请在弹出的菜单中选择用VScode打开当前目录   
   windows11系统请在弹出的菜单中选择显示更多选项 然后再点击用VScode打开当前目录这样就可以用vVScode打开项目了
   3. 在VScode中打开项目后打开文件夹中名称为main.py的文件这是项目的主程序
   4. 在键盘上按下F5来运行此项目如果出现窗口则说明项目运行成功，如果按照上面的教程没有成功的运行请把问题提交到Issues或者联系我们