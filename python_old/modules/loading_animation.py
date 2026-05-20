import sys
from math import pi
import pygame

pygame.init()

screen = pygame.display.set_mode((800, 600))

pygame.display.set_caption("pygame_test")

screen.fill((255,255,255))

wait_time = 25
starting_angle = 0#弧线起始角度
end_angle = pi/2#弧线结束角度
center_x,center_y = 400,300
radius = 25

while True:
    for event in pygame.event.get():#获取事件
        if event.type == pygame.QUIT:#判断是否点击了退出按钮
            pygame.quit()#退出pygame
            sys.exit()#终止系统
            quit()#退出程序
    screen.fill((255,255,255))
    rect = (center_x - radius,center_y - radius,radius*2,radius*2)
    pygame.draw.arc(screen,"blue",rect,starting_angle,end_angle,width=5)
    pygame.display.update()
    pygame.time.wait(wait_time)
    starting_angle += 0.05
    end_angle += 0.05
    