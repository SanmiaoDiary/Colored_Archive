#2025-7-13
import sys#导入系统模块
import pygame #导入pygame库
import math#导入数学模块
import json#导入json库——方便之后保存存档
import random#导入随机模块

pygame.init() #初始化pygame

screen = pygame.display.set_mode((1080, 600),pygame.RESIZABLE|pygame.SCALED)#设置屏幕大小
transparent_screen = pygame.Surface((1080, 600),pygame.SRCALPHA)#创建一个半透明的屏幕(用来绘制半透明的颜色)
pygame.display.set_caption("Colored Archive")#设置窗口标题
logo = pygame.image.load(r".\assets\images\slanted_logo.png").convert_alpha()
pygame.display.set_icon(logo)
font = pygame.font.Font(r".\assets\fonts\Minecraft AE(支持中文).ttf", 15)#引入字体类型 和字号
text = font.render("Colored Archive", True, (0, 0, 0),(255,255,255))#创建文字 文字内容 是否抗锯齿 颜色
textRect =text.get_rect()#获取文字的矩形坐标
textRect.center = (60, 600-20)#设置文字位置和坐标
screen.blit(text, textRect)#绘制文字

dark_blue = (0,0,139)#创建深蓝色
light_blue_translucent = (173,216,230,128)#创建淡蓝色（半透明）
yellow = (255,255,0)#创建黄色
gray_translucent = (128,128,128,180)#创建灰色（半透明）
black = (0,0,0)#创建黑色
white = (255,255,255)#创建白色
green_translucent = (0,255,0,128)#创建绿色（半透明）

#初始化modapi
modapi = None
try:#尝试导入modapi
    from modules import water
    modapi = water.Mod.loading_mods(screen)#示例化modapi Lading_mods类下的loading_mods方法，并把screen赋值给loading_mods
    print("成功加载modapi——water")
except Exception as error_information:
    print("【警告】:( 导入modAPI失败")
    print(f"错误原因：{error_information}")

runing = True
clock = pygame.time.Clock()
fullscreen = False
fps = 60#默认最高60帧
allow_click = []#所有允许点击的元素列表
draw_area = False#绘制区域
click_character = False#角色被点击
all_mission = {1:"Eliminate all Helmet Corps",
               2:"Destroy all helmet clan camps",
               3:"Destroy all robots",
               4:"Destroy all robot bases"}#所有任务
#消灭所有的头盔团 


class Mouse(pygame.sprite.Sprite):#创建鼠标类

    def __init__(self):#初始化
        super().__init__()#继承父类
        self.image = pygame.image.load(r".\assets\images\mouse.png").convert_alpha()#创建鼠标图片
        self.image_selectable = pygame.image.load(r".\assets\images\mouse_selectable.png").convert_alpha()#创建鼠标图片
        self.rect = self.image.get_rect()#获取鼠标的rect对象
        self.selected_area_rect = pygame.Rect(0, 0, 0, 0)#创建鼠标选择区域rect对象
        
    def update(self):#更新鼠标
        mouse_pos = pygame.mouse.get_pos()#获取鼠标位置
        for character in Character.all_characters.values():#遍历所有角色
            if character.character_rect.collidepoint(mouse_pos):#鼠标在角色上
                self.rect.center = (pygame.mouse.get_pos())#获得鼠标位置
                screen.blit(self.image_selectable,mouse_pos)#绘制鼠标可点击标记
            else:
                screen.blit(self.image,mouse_pos)#绘制鼠标
    
    def select_area(self,start_draw_x,start_draw_y):#绘制鼠标选择区域
        self.start_draw_x,self.start_draw_y = start_draw_x,start_draw_y#获取鼠标选择区域左上角坐标
        self.now_x,self.now_y = (pygame.mouse.get_pos())
        if self.start_draw_x >= self.now_x:
            if self.start_draw_y >= self.now_y:#鼠标在角色下边
                self.rect_width = self.start_draw_x - self.now_x#获取鼠标选择区域宽
                self.rect_height = self.start_draw_y - self.now_y#获取鼠标选择区域高
                self.rect_x = self.now_x#获取鼠标选择区域左上角x坐标
                self.rect_y = self.now_y#获取鼠标选择区域左上角y坐标
            elif self.start_draw_y < self.now_y:#鼠标在角色上边
                self.area_drawing_location = "bottom_left"
                self.rect_width = self.start_draw_x - self.now_x#获取鼠标选择区域宽
                self.rect_height = self.now_y - self.start_draw_y#获取鼠标选择区域高
                self.rect_x = self.now_x#获取鼠标选择区域左上角x坐标
                self.rect_y = self.start_draw_y#获取鼠标选择区域左上角y坐标
        if self.start_draw_x <= self.now_x:#鼠标在角色左边
            if self.start_draw_y >= self.now_y:
                self.area_drawing_location = "top_right"
                self.rect_width = self.now_x - self.start_draw_x#获取鼠标选择区域宽
                self.rect_height = self.start_draw_y - self.now_y#获取鼠标选择区域高
                self.rect_x = self.start_draw_x#获取鼠标选择区域左上角x坐标
                self.rect_y = self.now_y#获取鼠标选择区域左上角y坐标
            elif self.start_draw_y < self.now_y:#鼠标在角色下边
                self.area_drawing_location = "bottom_right"
                self.rect_width = self.now_x - self.start_draw_x#获取鼠标选择区域宽
                self.rect_height = self.now_y - self.start_draw_y#获取鼠标选择区域高
                self.rect_x = self.start_draw_x#获取鼠标选择区域左上角x坐标
                self.rect_y = self.start_draw_y

        self.selected_area_rect = pygame.Rect(self.rect_x,self.rect_y,self.rect_width,self.rect_height) #创建鼠标选择区域rect对象      
        self.selected_area = pygame.draw.rect(screen,dark_blue,(self.rect_x,self.rect_y,self.rect_width,self.rect_height),1)#绘制鼠标选择区域的边框
        pygame.draw.rect(transparent_screen,light_blue_translucent,(self.rect_x+1,self.rect_y+1,self.rect_width-2,self.rect_height-2))#绘制鼠标选择区域的填充部分
        


class Character():#创建角色类
    game_all_characters = {0:"cat",10010:"Sunaookami_Shiroko"}
    #游戏允许拥有的所有角色，在一个地图里面同样的角色只能出现一个（同个角色不同皮肤可以存在）
    #前面是数字是角色的代号，方便识别角色
    all_reinforcement_characters_chosen_by_the_player = []#玩家选择可以增援的角色
    total_number_of_characters = 0#地图上的角色总数
    character_limit = 24#一个地图允许存在的最大角色数量
    gun_owned_by_the_character = {10010:""}#游戏里面允许角色拥有的枪械 如果没写表示ta可以使用任何武器
    characters_speed = {0:120,10010:150}#所有允许存在的角色的移动速度s
    characters_run_speed = {0:200,10010:250}#所有允许存在的角色的奔跑速度
    characters_command_list = {0:["run","fire_mode","fire_strategy","open_backpack","fire_suppression"],#所有允许存在的角色可以执行的命令
                               10010:["run","fire_mode","fire_strategy","open_backpack","fire_suppression"]}
    #run:跑 fire_mode:开火模式 fire_strategy:开火策略 open_backpack:打开背包 fire_suppression:火力压制
    armored_type = {0:"no_armor",1:"light_armor",2:"medium_armor",3:"heavy_armor",4:"tank"}#角色护甲类型
    #0：没有装甲 1：轻型装甲 2：中型装甲 3：重型装甲 4：坦克
    characters_HP = {0:100,10010:100}#所有允许存在的角色的生命值
    all_characters = {}#所有在地图上出现的角色 储存所有出现的角色的所有的信息 key:角色id value:角色信息
    
    def __init__(self,x,y,id):#初始化
        self.name = self#创建角色名称
        
        if id in Character.all_characters: #如果角色的id等于现在地图上有了的角色
            print("【错误】角色创建失败：地图上已存在同名角色！") #提示角色已经在地图上存在
            pass#跳出执行
               
        allow_click.append(self)#允许鼠标点击角色
        self.id = id#创建角色id
        self.speed = Character.characters_speed[id]#获取角色移动速度
        self.max_HP = Character.characters_HP[id]#获取当前角色的最大生命值
        self.now_HP = Character.characters_HP[id]#获取当前角色的生命值
        self.character = pygame.image.load(r".\assets\images\cat.png").convert_alpha()#创建角色图片
        self.selection_marker = pygame.image.load(r".\assets\images\character_selection_marker.png").convert_alpha()#创建一个角色选中标记
        self.character_rect = self.character.get_rect()#获取角色的矩形坐标
        self.character_rect.x,self.character_rect.y = x,y#初始化创建角色的位置
        self.selected = False#设置角色是否被选中
        self.destination_x,self.destination_y = self.character_rect.x,self.character_rect.y#创建角色目的地坐标
        Character.all_characters[self.id] = self#把角色的实例信息储存在字典中
        Character.total_number_of_characters += 1
        print("【提示】角色创建成功！")
        self.create_Character_Information_Display_Bar = Character_Information_Display_Bar(x,y,id)#创建角色信息显示栏
    def update(self,frame_occupancy_time):#更新角色和选中标记 screen:绘制在主窗口上
        self.create_Character_Information_Display_Bar.update(self.character_rect.x,self.character_rect.y,self.id)#更新角色信息显示栏
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
        if self.now_HP <= 0: #角色生命值小于等于0
            self.all_characters.remove(self)#删除角色
            allow_click.remove(self)#不允许鼠标点击角色

    def select(self):#角色被选中
        self.selected = True#设置角色被选中
        print("【提示】角色被选中！")

    def deselect(self):#角色被取消选中
        self.selected = False#设置角色被取消选中
        print("【提示】角色被取消选中！")

class Enemy():#创建敌人类
    game_all_enemys = {10:"block_robot",11:"self_detonating_block_robot"}#游戏允许出现的敌人 
    #编号涵义：xx 第一个数字：1：方块机器人系列 第二个数字：在这个系列里面的第几个
    game_all_enemys_hp = {10:440,11:440}#存储所有允许存在的敌人生命值
    all_enemys_hp = {10:100,11:100}#存储所有允许存在的敌人生命值
    all_enemys_speed = {10:120,11:120}#存储所有允许存在的敌人移动速度
    total_number_of_enemies = 0#敌人总数
    armored_type = {0:"no_armor",1:"light_armor",2:"medium_armor",3:"heavy_armor",4:"tank"}#敌人护甲类型
    #0：没有装甲 1：轻型装甲 2：中型装甲 3：重型装甲 4：坦克
    all_enemys = []
    def __init__(self,x,y,type_of_troops,id):#初始化 type_of_troops:敌人所在的部队类型（不同部队的敌人策略不同）
        self.name = self
        self.id = 10
        
        if Enemy.total_number_of_enemies >= Character.total_number_of_characters * 5:#如果敌人总数大于等于角色总数*5就停止创建敌人
            print("【警告】敌人创建失败，地图上敌人总数已达到上限！")
            pass
        else:
            Enemy.all_enemys.append(self)#把敌人加入到所有敌人列表
            Enemy.total_number_of_enemies += 1#敌人总数加1
            self.type_of_troops = type_of_troops#创建一个变量来存储这个敌人所属的部队类型 方便后面判断敌人策略
        
        self.enemy = pygame.image.load(r".\assets\images\cat.png").convert_alpha()#创建敌人图片
        self.enemy_rect = self.enemy.get_rect()#获取敌人矩形坐标
        self.enemy_rect.x,self.enemy_rect.y = x,y#初始化创建敌人的位置
        self.hp = Enemy.game_all_enemys_hp[id]#获取敌人生命值
        self.speed = Enemy.game_all_enemys_speed[id]#获取敌人移动速度
        self.armored_type = Enemy.armored_type[id]#获取敌人护甲类型
        print("【提示】敌人创建成功！")
    def update(self):
        screen.blit(self.enemy, (self.enemy_rect.x,self.enemy_rect.y))#绘制测试敌人
        if self.type_of_troops == "defense_troops":#如果是防御部队策略应该更偏向防守
            pass
        elif self.type_of_troops == "patrol_troops":#如果是巡逻部队策略应该更偏向进攻
            pass
        
        if self.hp <= 0: #敌人生命值小于等于0
            self.all_enemys.remove(self)#删除敌人
            allow_click.remove(self)#不允许鼠标点击敌人
        

    def reinforcement(self):
        pass

class Gun():#创建枪类

    def __init__(self,character_x,character_y,character_id,gun_id):
        pass

class saves():#创建存档类
    def __init__(self):
        pass

class button():#创建按钮类

    def __init__(self,x,y,width,height,purposes):
        self.x = x#创建按钮x坐标
        self.y = y#创建按钮y坐标
        self.width = width#创建按钮宽度
        self.height = height#创建按钮高度
        self.purposes = purposes#创建按钮用途
        if purposes == "reinforcements":#如果用途是增援
            self.reinforcements_button = pygame.draw.rect(screen,yellow,(self.x,self.y,self.width,self.height))#创建增援按钮
            self.reinforcements_button_rect = pygame.Rect(self.x,self.y,self.width,self.height)#创建按钮矩形
            # self.button = pygame.image.load(r"\assets\images\reinforcements_button.png").convert_alpha()#加载按钮图片
            # self.button_rect = pygame.Rect(self.x,self.y,self.width,self.height)#创建按钮矩形
    def update(self):
        if game_mouse.clicked == True and self.button_rect.colliderect(self.button_rect) == True:#如果鼠标点击了按钮
            if self.purposes == "reinforcements":
                menu.draw_select_reinforcement_character_menu()#绘制选择增援角色菜单

class menu():#创建菜单类
    def __init__(self,x,y,width,height,purposes):#创建菜单类
        pass
    def draw_select_reinforcement_character_menu():#绘制选择增援角色菜单
        pass

    def update(self):#更新菜单
        pass

class Map():
    def __init__(self,width,height,x,y):#创建地图类 x 左上角的x坐标 y 左上角的y坐标
        self.width = width#地图宽度
        self.height = height#地图高度
        self.x = x#地图左上角的x坐标
        self.y = y#地图左上角的y坐标
        self.grass_green = pygame.image.load(r".\assets\images\grass_green.png").convert_alpha()#创建地图绿色的草地
        self.grass_green_yellow = pygame.image.load(r".\assets\images\grass_yellow.png").convert_alpha()#创建地图黄色的草地
        self.map_save = {}#存储地图的字典 键值：地块的在整个地图的位置 值：地块的贴图
        for i in range(self.height):#创建地图
            for j in range(self.width):
                map_creater = int(random.randint(0,1))#开始根据随机数创建地图
                if map_creater == 0:
                    self.map_save[i,j] = self.grass_green#将地块的位置和grass_green 贴图信息保存到字典中
                elif map_creater == 1:
                    self.map_save[i,j] = self.grass_green_yellow#将这个地块的位置和 grass_green_yellow 的贴图信息保存到字典中
    def update(self):
        for i in range(self.height):#绘制地图（按高度）
            for j in range(self.width):#绘制地图（按宽度）
                screen.blit(self.map_save[i,j],(self.x+j*32,self.y+i*32))#绘制地图

def move_map_and_characters(movement_distance_x,movement_distance_y):#移动地图和角色
    window_width,window_height = screen.get_size()#获取窗口的宽高
    max_x = 0#最大x坐标
    max_y = 0#最大y坐标
    min_x = -(game_map.width * 32 - window_width)#最小x坐标
    min_y = -(game_map.height * 32 - window_height)#最小y坐标
    new_x = game_map.x + movement_distance_x#要移动到的x坐标
    new_y = game_map.y + movement_distance_y#要移动到的y坐标
    if new_x > max_x:#如果移动后的地图x坐标等于最大x坐标
        new_x = max_x#直接把地图的x坐标设置为最大x坐标
    elif new_x < min_x:#如果移动后的地图x坐标等于最小x坐标
        new_x = min_x#直接把地图的x坐标设置为最小x坐标
    if new_y > max_y:#如果移动后的地图y坐标等于最大y坐标
        new_y = max_y#直接把地图的y坐标设置为最大y坐标
    elif new_y < min_y:#如果移动后的地图y坐标等于最小y坐标
        new_y = min_y#直接把地图的y坐标设置为最小y坐标
    
    character_actual_distance_x = new_x - game_map.x#实际的移动距离x
    character_actual_distance_y = new_y - game_map.y#实际的移动距离y
    game_map.x = new_x#移动地图x坐标
    game_map.y = new_y#移动地图y坐标
    for character in Character.all_characters.values():#遍历所有角色
        character.character_rect.x += character_actual_distance_x#移动角色的位置
        character.destination_x += character_actual_distance_x#移动角色目的地的位置
        character.character_rect.y += character_actual_distance_y#移动角色的位置
        character.destination_y += character_actual_distance_y#移动角色目的地的位置
class Stratagem():#创建战略配备类
    all_stratagem = {0:"Reinforce",
                     1:"Resupply",
                     2:"L118 light gun shelling"}#所有战略配备
    #0：增援 1：补给 2：L118榴弹炮炮击

class Character_Information_Display_Bar():#创建角色信息显示条类
    all_character_information_display_bar = []#创建角色信息显示条列表
    def __init__(self,character_x,character_y,character_id):
        self.character_name = Character.game_all_characters[character_id]#获取角色名字
        Character_Information_Display_Bar.all_character_information_display_bar.append(character_id)#添加角色id到角色信息显示条字典中
        self.character_x = character_x#设置角色信息显示条的x坐标
        self.character_x = character_y#设置角色信息显示条的y坐标
        
    def update(self,character_x,character_y,character_id):
        window_width,window_height = screen.get_size()#获取窗口的宽高
        position_offset_x = 20#角色信息显示条x坐标的偏移量
        position_offset_y = 15#角色信息显示条y坐标的偏移量
        character = Character.all_characters[character_id]#获取角色的所有信息
        if character_y >= 0 + position_offset_y and character_y <= window_height - position_offset_y:#如果角色信息显示条的位置在窗口内就正常的（显示在角色上方）显示角色信息显示条
            self.character_x = character_x#设置角色信息显示条的x坐标
            self.character_y = character_y - position_offset_y#设置角色信息显示条的y坐标
            character_name_x = self.character_x + 15#角色名字x坐标的偏移量
            character_name_y = self.character_y #角色名字y坐标的偏移量
            draw_character_name = font.render(self.character_name,True,white)#绘制角色名字
            draw_character_name_rect = draw_character_name.get_rect()#获取角色名字的矩形(因为每个角色名字的矩形都不一样大)
            draw_character_name_rect.center = (character_name_x,character_name_y)#设置角色名字的位置
            pygame.draw.rect(transparent_screen,gray_translucent,draw_character_name_rect.inflate(8,8))#在透明的屏幕上绘制角色名字的背景
            transparent_screen.blit(draw_character_name,draw_character_name_rect)#在透明的屏幕上绘制角色名字
            #接下来我们来绘制角色的血条
            draw_name_background_rect = draw_character_name_rect.inflate(8,8)#获取角色名字的背景的矩形 方便下面的计算
            self.now_HP = character.now_HP#获取角色的当前生命值
            self.max_HP = character.max_HP#获取角色的最大生命值
            HP_bar_max_width = 100#血条的最大宽度(像素)
            HP_bar_width = self.now_HP / self.max_HP * HP_bar_max_width#获取角色的血条宽度
            HP_bar_height = draw_name_background_rect.height - 4#血条的高度 -4 是给血条居中显示
            HP_bar_background_width = HP_bar_width + 4#血条的背景宽度
            HP_bar_background_height = draw_name_background_rect.height#血条的背景高度 把角色名字的矩形的高度当作血条背景的高度（与显示角色名字的条齐平）
            HP_bar_background_x = draw_name_background_rect.right + 2#设置血条背景的x坐标
            HP_bar_background_y = draw_name_background_rect.top#设置血条背景的y坐标
            HP_bar_x = HP_bar_background_x + 2#血条的x坐标
            HP_bar_y = HP_bar_background_y + 2#设置血条的y坐标
            pygame.draw.rect(transparent_screen,gray_translucent,(HP_bar_background_x,HP_bar_background_y,HP_bar_background_width,HP_bar_background_height))#绘制血条的背景
            pygame.draw.rect(transparent_screen,green_translucent,(HP_bar_x,HP_bar_y,HP_bar_width,HP_bar_height),0,10)#绘制血条
        
        else:#如果角色跑到窗口外面去了就不显示角色信息显示条了
            return#跳出函数
        
pygame.mouse.set_visible(False)#隐藏系统鼠标
game_mouse = Mouse()#实例化鼠标类
cat = Character(540,300,0)#实例化角色类_小猫
reinforcements_button = button(250,250,100,100,"reinforcements")#实例化增援按钮
game_map = Map(256,256,-20,-20)

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
                screen_width,screen_height = screen.get_size()#获取屏幕宽高
                transparent_screen = pygame.Surface((screen_width, screen_height),pygame.SRCALPHA)#重新创建一个透明背景
        # 是否选中角色/角色是否要移动逻辑判断
        for character in Character.all_characters.values():#遍历所有角色
            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1: #如果鼠标左键被按下
                if character.character_rect.collidepoint(pygame.mouse.get_pos()): #如果鼠标在角色上
                    click_character = True
                    if character.selected == True: #如果角色被选中那就取消选中
                        character.deselect()
                    else:#如果角色没有被选中那就选中角色
                        character.select()
                else: #如果鼠标不在角色上被点击
                    if character.selected == True: #如果角色被选中
                        character.destination_x,character.destination_y = (pygame.mouse.get_pos())#记录下鼠标位置方便移动
                        character.deselect()#取消角色选中方便玩家选中其他角色进行移动
                    

    screen.fill((240, 240, 240))#填充屏幕（相当于清屏）
    transparent_screen.fill((0,0,0,0)) #填充透明屏幕

    frame_occupancy_time = clock.tick(fps) / 1000.0#获取帧占用时间
    game_map.update()#绘制地图
    cat.update(frame_occupancy_time)#更新角色
    
    # 绘制选中角色方框
    if pygame.mouse.get_pressed()[0] == True:#判断是否点击了鼠标左键
        if draw_area == False:#如果没有正在绘制
            start_drawing_x,start_drawing_y = pygame.mouse.get_pos()#记录下鼠标位置方便之后绘制选中角色的方框
            draw_area = True
        elif event.type == pygame.MOUSEBUTTONUP and event.button == 1:#如果鼠标左键被松开
            if draw_area == True:#如果正在绘制
                game_mouse.select_area(start_drawing_x,start_drawing_y)#绘制选中角色方框
                draw_area = False#停止绘制
                for character in Character.all_characters.values():#遍历所有角色来判断角色是否被方框选中
                    if game_mouse.selected_area_rect.colliderect(character.character_rect): #如果框选角色就选中
                        character.select()#选中被框选的角色
                    else:
                        character.deselect()#取消角色选中
                 
    else:#如果没有点击鼠标左键
        #地图移动逻辑判断
        keys = pygame.key.get_pressed()#获取按键
        movement_distance = 15#移动距离
        if keys[pygame.K_w]:#判断是否按下了W键
            if keys[pygame.K_a]:
                move_map_and_characters(movement_distance,movement_distance)#向左上方移动地图和角色
            elif keys[pygame.K_d]:
                move_map_and_characters(-movement_distance,movement_distance)#向右上方移动地图和角色
            else:
                move_map_and_characters(0,movement_distance)#向上方移动地图和角色
        elif keys[pygame.K_s]:#判断是否按下了S键
            if keys[pygame.K_a]:
                move_map_and_characters(movement_distance,-movement_distance)#向左下方移动地图和角色
            elif keys[pygame.K_d]:
                move_map_and_characters(-movement_distance,-movement_distance)#向右下方移动地图和角色
            else:
                move_map_and_characters(0,-movement_distance)#向下方移动地图和角色
        elif keys[pygame.K_a]:#判断是否按下了A键
            move_map_and_characters(movement_distance,0)#移动地图和角色
        elif keys[pygame.K_d]:#判断是否按下了D键     
            move_map_and_characters(-movement_distance,0)#移动地图和角色

    screen.blit(transparent_screen, (0,0))#绘制透明屏幕
    show_fps = font.render("FPS: " + str(int(clock.get_fps())), True,(0, 0, 0),(255,225,225))
    textRect =show_fps.get_rect()#获取文字的矩形坐标
    textRect.center = (40, 10)#设置文字位置和坐标
    screen.blit(show_fps, textRect)#绘制文字
    game_mouse.update()#在显示fps之后更新鼠标 防止fps挡住鼠标  
    pygame.display.update()#更新屏幕
    clock.tick(fps)