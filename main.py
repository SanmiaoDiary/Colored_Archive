#2025-7-13
import sys
import pygame #导入pygame库

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
    print(":( 导入modAPI失败")
    print(f"错误原因：{error_information}")

runing = True
clock = pygame.time.Clock()
fullscreen = False
fps = 60#默认最高60帧

class Mouse(pygame.sprite.Sprite):#创建鼠标类

    def __init__(self):#初始化
        super().__init__()#继承父类
        self.image = pygame.image.load(r"image\mouse.png").convert_alpha()#创建鼠标图片
        self.image_selectable = pygame.image.load(r"image\mouse_selectable.png").convert_alpha()#创建鼠标图片
        self.rect = self.image.get_rect()#获取鼠标的rect对象
        
    def update(self):#更新鼠标
        if character.character_rect.collidepoint(pygame.mouse.get_pos()):#鼠标在角色上
           self.rect.center = (pygame.mouse.get_pos())
           screen.blit(self.image_selectable,pygame.mouse.get_pos())
        else:
            screen.blit(self.image,pygame.mouse.get_pos())#绘制鼠标
    

class Character():#创建角色类
    all_characters = []
    selected = False
    def __init__(self,x,y):#初始化
        # character.all_characters.add(self) = []#把角色名字加入到所有角色列表
        self.character = pygame.image.load(r"image\cat.png").convert_alpha()#创建角色图片
        self.selection_marker = pygame.image.load(r".\image\character_selection_marker.png").convert_alpha()#创建一个角色选中标记
        self.character_rect = self.character.get_rect()#获取角色的矩形坐标
        self.character_rect.x,self.character_rect.y = x,y#初始化创建角色的位置
        self.all_characters.append(self)
        
    def update(self,screen):#更新角色和选中标记 screen:绘制在哪个窗口上
        if self.selected == True:
            screen.blit(self.selection_marker,(self.character_rect.x,self.character_rect.y))#绘制角色选中标记
        screen.blit(self.character, (self.character_rect.x,self.character_rect.y))#绘制测试角色——小猫    

    def select(self):#角色被选中
        self.clicked = True#设置角色被选中
        print("角色被选中")

    def deselect(self):#角色被取消选中
        self.clicked = False#设置角色被取消选中
        print("角色被取消选中")

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
        
    screen.fill((240, 240, 240))

    game_mouse = Mouse()#实例化鼠标类
    cat = Character(540, 300)#实例化角色类_小猫
    

    left,middle, right = pygame.mouse.get_pressed()#获取鼠标按键状态
    # 是否选中角色逻辑判断
    for character in Character.all_characters:#遍历所有角色
        if left == True: #如果鼠标左键被按下
            if character.character_rect.collidepoint(pygame.mouse.get_pos()): #如果鼠标在角色上
                
                if character.selected == True: #如果角色被选中那就取消选中
                    character.deselect()
                else:#如果角色没有被选中那就选中角色
                    character.select()
            else: #如果鼠标不在角色上
                mouse_x,mouse_y = (pygame.mouse.get_pos())#记录下鼠标位置方便移动
        
        cat.update(screen)
    game_mouse.update()    
    show_fps = font.render("FPS: " + str(int(clock.get_fps())), True,(0, 0, 0),(255,225,225))
    textRect =show_fps.get_rect()#获取文字的矩形坐标
    textRect.center = (40, 10)#设置文字位置和坐标
    screen.blit(show_fps, textRect)#绘制文字
    pygame.display.update()#更新屏幕
    clock.tick(fps)