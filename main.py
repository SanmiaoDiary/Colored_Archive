#2025-7-13
import sys#导入系统模块
import pygame #导入pygame库
import math#导入数学模块

pygame.init() #初始化pygame

screen = pygame.display.set_mode((1080, 600),pygame.RESIZABLE|pygame.SCALED)#设置屏幕大小
pygame.display.set_caption("Colored Archive")#设置窗口标题
logo = pygame.image.load(r"image\slanted_logo.png").convert_alpha()
pygame.display.set_icon(logo)
font = pygame.font.Font(r".\fonts\Minecraft AE(支持中文).ttf", 15)#引入字体类型 和字号
text = font.render("Colored Archive", True, (0, 0, 0),(255,255,255))#创建文字 文字内容 是否抗锯齿 颜色
textRect =text.get_rect()#获取文字的矩形坐标
textRect.center = (60, 600-20)#设置文字位置和坐标
screen.blit(text, textRect)#绘制文字

#初始化modapi
modapi = None
try:
    from mods.water import water
    modapi = water.Mod.loading_mods(screen)#示例化modapi Lading_mods类下的loading_mods方法，并把screen赋值给loading_mods
    print("成功加载mod")
except Exception as error_information:
    print("【警告】:( 导入modAPI失败")
    print(f"错误原因：{error_information}")

runing = True
clock = pygame.time.Clock()
fullscreen = False
fps = 60#默认最高60帧
allow_click = []#所有允许点击的元素列表

class Mouse(pygame.sprite.Sprite):#创建鼠标类

    def __init__(self):#初始化
        super().__init__()#继承父类
        self.image = pygame.image.load(r"image\mouse.png").convert_alpha()#创建鼠标图片
        self.image_selectable = pygame.image.load(r"image\mouse_selectable.png").convert_alpha()#创建鼠标图片
        self.rect = self.image.get_rect()#获取鼠标的rect对象
        
        
    def update(self):#更新鼠标
        mouse_pos = pygame.mouse.get_pos()#获取鼠标位置
        if character.character_rect.collidepoint(mouse_pos):#鼠标在角色上
           self.rect.center = (pygame.mouse.get_pos())#获得鼠标位置
           screen.blit(self.image_selectable,mouse_pos)#绘制鼠标可点击标记
        else:
            screen.blit(self.image,mouse_pos)#绘制鼠标
    

class Character():#创建角色类
    game_all_characters = {0:"cat",1001:"Sunaookami_Shiroko"}
    #游戏允许拥有的所有角色，在一个地图里面同样的角色只能出现一个（同个角色不同皮肤可以存在）
    #前面是数字是角色的代号，方便识别角色
    characters_speed = {0:120,1001:70}#所有允许存在的角色的移动速度
    characters_HP = {0:100,1001:100}#所有允许存在的角色的生命值
    all_characters = []#所有在地图上出现的角色 储存所有出现的角色的名字
    
    def __init__(self,x,y,id):#初始化
        self.name = self#创建角色名称
        
        if id == Character.game_all_characters: #如果角色的id等于游戏允许拥有角色的id
            print("【错误】角色创建失败：地图上已存在同名角色") #提示角色已经在地图上存在
            return
        else:        
            Character.all_characters.append(self)#把角色加入到所有角色列表
            allow_click.append(self)#允许鼠标点击角色

        self.speed = Character.characters_speed[id]#获取角色移动速度
        self.HP = Character.characters_HP[id]
        self.character = pygame.image.load(r"image\cat.png").convert_alpha()#创建角色图片
        self.selection_marker = pygame.image.load(r".\image\character_selection_marker.png").convert_alpha()#创建一个角色选中标记
        self.character_rect = self.character.get_rect()#获取角色的矩形坐标
        self.character_rect.x,self.character_rect.y = x,y#初始化创建角色的位置
        self.selected = False#设置角色是否被选中
        self.destination_x,self.destination_y = self.character_rect.x,self.character_rect.y#创建角色目的地坐标

    def update(self,frame_occupancy_time):#更新角色和选中标记 screen:绘制在主窗口上
        if (self.destination_x,self.destination_y) != (self.character_rect.x,self.character_rect.y):#角色没有到达目的地就继续向目的地移动
            destination = math.hypot(self.destination_x - self.character_rect.x , self.destination_y - self.character_rect.y)#获取角色到目的地的距离
            step = self.speed * frame_occupancy_time #计算角色这一帧应该移动多少像素
            if destination <= step:#如果剩下的距离比算出来的要前进的距离要小或者距离相等就直接过去
                self.character_rect.x,self.character_rect.y = self.destination_x,self.destination_y#直接让角色到达目的地
                self.destination_x,self.destination_y = self.character_rect.x,self.character_rect.y#再次把角色的目的地设置为当前位置
            else:
                self.character_rect.x += step * (self.destination_x - self.character_rect.x) / destination#计算角色应该移动到哪里
                self.character_rect.y += step * (self.destination_y - self.character_rect.y) / destination#计算角色应该移动到哪里
        #移动之后再重新绘制角色的图像
        if self.selected == True:#如果角色被选中
            screen.blit(self.selection_marker,(self.character_rect.x,self.character_rect.y))#绘制角色选中标记
        screen.blit(self.character, (self.character_rect.x,self.character_rect.y))#绘制测试角色——小猫    
        if self.HP <= 0: #角色生命值小于等于0
            self.all_characters.remove(self)#删除角色
            allow_click.remove(self)#不允许鼠标点击角色

    def select(self):#角色被选中
        self.selected = True#设置角色被选中
        print("【提示】角色被选中")

    def deselect(self):#角色被取消选中
        self.selected = False#设置角色被取消选中
        print("【提示】角色被取消选中")

pygame.mouse.set_visible(False)#隐藏系统鼠标
game_mouse = Mouse()#实例化鼠标类
cat = Character(540,300,0)#实例化角色类_小猫

while runing == True: #游戏循环
    for event in pygame.event.get():#获取事件
        if event.type == pygame.QUIT:#判断是否点击了退出按钮
            pygame.quit()#退出pygame
            sys.exit()#终止系统
            quit()#退出程序
        
        elif event.type == pygame.KEYDOWN:#判断是否按下了按键
            if event.key == pygame.K_F11:#判断是否按下了F11键
                fullscreen = not fullscreen
                if fullscreen:
                    screen = pygame.display.set_mode((0, 0),pygame.FULLSCREEN|pygame.HWSURFACE|pygame.DOUBLEBUF)
                else:
                    screen = pygame.display.set_mode((1080,600),pygame.RESIZABLE)
        
        # 是否选中角色逻辑判断
        for character in Character.all_characters:#遍历所有角色
            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1: #如果鼠标左键被按下
                if character.character_rect.collidepoint(pygame.mouse.get_pos()): #如果鼠标在角色上
                    
                    if character.selected == True: #如果角色被选中那就取消选中
                        character.deselect()
                    else:#如果角色没有被选中那就选中角色
                        character.select()
                else: #如果鼠标不在角色上被点击
                    cat.destination_x,cat.destination_y = (pygame.mouse.get_pos())#记录下鼠标位置方便移动
                    character.deselect()#取消角色选中方便玩家选中其他角色进行移动
            
    screen.fill((240, 240, 240))#填充屏幕（相当于清屏） 
    frame_occupancy_time = clock.tick(fps) / 1000.0#获取帧占用时间
    cat.update(frame_occupancy_time)#更新角色
     
    show_fps = font.render("FPS: " + str(int(clock.get_fps())), True,(0, 0, 0),(255,225,225))
    textRect =show_fps.get_rect()#获取文字的矩形坐标
    textRect.center = (40, 10)#设置文字位置和坐标
    screen.blit(show_fps, textRect)#绘制文字
    game_mouse.update()#在显示fps之后更新鼠标 防止fps挡住鼠标  
    pygame.display.update()#更新屏幕
    clock.tick(fps)