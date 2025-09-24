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

can_press = False

class Mouse():
    def __init__(self):
        self.rect = self.image.get_rect()
        self.image = pygame.image.load(r"image\mouse.png").convert_alpha()
        self.image_selectable = pygame.image.load(r"image\mouse_selectable.png").convert_alpha()
    def update(self):
        self.xy= pygame.mouse.get_pos()
        if can_press == True:
            screen.blit(self.image_selectable, self.xy)
        screen.blit(self.image, self.xy)

class Character():
    all_characters = {0:"cat",1:""}
    selected = False
    def __init__(self,x,y):
        self.character_rect = self.character.get_rect()
        self.character = pygame.image.load(r"image\cat.png").convert_alpha()
        self.selection_marker = pygame.image.load(r".\image\character_selection_marker.png").convert_alpha()
    def deselect(self):
        self.selected = False
        