#2025-7-13
import sys, importlib.util, pathlib
import pygame #导入pygame库
from mods.water import waterapi

pygame.init() #初始化pygame

#初始化modapi
modapi = waterapi()#实例化mods类
modapi.lading_mods()

screen = pygame.display.set_mode((1080, 600),pygame.RESIZABLE|pygame.SCALED)#设置屏幕大小
pygame.display.set_caption("Colored Archive")#设置窗口标题
logo = pygame.image.load(r"image\slanted_logo.png").convert()
pygame.display.set_icon(logo)
font = pygame.font.Font(r".\fonts\Minecraft AE(支持中文).ttf", 15)#引入字体类型 和字号
text = font.render("Colored Archive", True, (0, 0, 0),(255,255,255))#创建文字 文字内容 是否抗锯齿 颜色
textRect =text.get_rect()#获取文字的矩形坐标
textRect.center = (60, 600-20)#设置文字位置和坐标
screen.blit(text, textRect)#绘制文字

runing = True
clock = pygame.time.Clock()
fullscreen = False
fps = 60#默认锁60帧

class mouse(pygame.sprite.Sprite):#创建鼠标类
    def __init__(self):#初始化
        self.mouse = pygame.image.load(r"image\mouse.png").convert
        self.rect = self.mouse.get_rect()#获取图片的矩形坐标
        mouse_x,mouse_y = pygame.mouse.get_pos()#获取鼠标的位置
        screen.blit(self.mouse,mouse_x,mouse_y)#绘制鼠标
        return mouse_x,mouse_y
    def update(self):#更新鼠标
        self.rect.center = (pygame.mouse.get_pos())
        mouse_x,mouse_y = pygame.mouse.get_pos()#获取鼠标的位置
        screen.blit(self.mouse,self.rect.center)#绘制鼠标
        return mouse_x,mouse_y
    def selectable(self):
        self.rect.center = (pygame.mouse.get_pos())
        self.mouse = pygame.image.load(r"image\mouse_selectable.png").convert
        screen.blit(self.mouse,self.rect.center)

character_x, character_y = 540,300#创建角色的位置
class characters():#创建角色类
    clicked = False
    def __init__(self):#初始化
        self.rect = self.image.get_rect()#获取图片的矩形坐标
        if characters.clicked == True:#如果角色已经被点击了那么就继续绘制角色选标
            character_selection_marker = pygame.image.load(".\image\character_selection_marker.png").convert()#创建一个角色选中标记
            screen.blit(character_selection_marker, (character_x, character_y))#在角色的位置上绘制选中标记
            screen.blit(character, (character_x, character_y))#绘制角色防止被覆盖
        
    def clicked():#角色被点击
        characters.clicked = True
        character_selection_marker = pygame.image.load(".\image\character_selection_marker.png").convert()#创建一个角色选中标记
        screen.blit(character_selection_marker, (character_x, character_y))#在角色的位置上绘制选中标记
        screen.blit(character, (character_x, character_y))#绘制角色防止被覆盖
        print("角色被选中")

while runing == True: #游戏循环
    for event in pygame.event.get():#获取事件
        if event.type == pygame.QUIT:#判断是否点击了退出按钮
            pygame.quit()#退出pygame
            sys.exit()#终止系统
            quit()#退出程序
        
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_F11:
                fullscreen = not fullscreen
                if fullscreen:
                    screen = pygame.display.set_mode((0, 0),pygame.FULLSCREEN|pygame.HWSURFACE|pygame.DOUBLEBUF)
                else:
                    screen = pygame.display.set_mode((1080,600),pygame.RESIZABLE)
        
    screen.fill((240, 240, 240))
    game_mouse = mouse()#实例化鼠标类

    character = characters(character_x, character_y)#实例化角色类

    left,middle, right = pygame.mouse.get_pressed()
    # 判断是否选中角色
    character_rect = character.get_rect(center=(character_x, character_y))
    if left and character_rect.collidepoint(pygame.mouse.get_pos()): #判断鼠标左键是否被按下且在角色矩形范围内
        characters.clicked()

    
    show_fps = font.render("FPS: " + str(int(clock.get_fps())), True,(0, 0, 0),(255,225,225))
    textRect =show_fps.get_rect()#获取文字的矩形坐标
    textRect.center = (40, 10)#设置文字位置和坐标
    screen.blit(show_fps, textRect)#绘制文字
    pygame.display.update()#更新屏幕
    clock.tick(fps)