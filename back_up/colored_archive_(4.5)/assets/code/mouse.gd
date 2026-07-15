extends Node2D

#@onready var polygon2D :=$"Polygon2D"#定义形状节点
#@onready var area2D := $"Polygon2D/Area2D"#定义碰撞区域节点
var mouse64x64 = preload("res://assets/images/mouse_64x64.png")#提前加载鼠标图标(64x64版本)
var mouse_selectable64x64 = preload("res://assets/images/mouse_selectable_64x64.png")#提前加载鼠标可以点击的图标(64x64版本)
var mouse32x32 = preload("res://assets/images/mouse_32x32.png")#提前加载鼠标图标(32x32版本)
var mouse_selectable32x32 = preload("res://assets/images/mouse_selectable_32x32.png")#提前加载鼠标图标(32x32版本)
var window_hight#窗口的高
var mouse_style#鼠标样式
var selectable=false#当前鼠标指向的项目可否被点击，默认为否

func set_mouse_icon():#设置鼠标图标的函数
	window_hight = get_viewport().get_visible_rect().size.y#获取窗口的高
	if selectable:
		if window_hight>2000:#如果屏幕是4k的分辨率
			mouse_style="64x64"
			Input.set_custom_mouse_cursor(mouse_selectable64x64)#初始化鼠标图标为可点击（64x64版本）
		else:
			mouse_style="32x32"
			Input.set_custom_mouse_cursor(mouse_selectable32x32)#初始化鼠标图标为可点击（32x32版本）
	else:
		if window_hight>=2000:#如果屏幕是4k的分辨率
			mouse_style="64x64"
			Input.set_custom_mouse_cursor(mouse64x64)#初始化鼠标图标为常规（64x64版本）
		else:
			mouse_style="32x32"
			Input.set_custom_mouse_cursor(mouse32x32)#初始化鼠标图标为常规（32x32版本）
	
func _ready() -> void:
	set_mouse_icon()#设置鼠标图标
	
func _process(delta: float) -> void:
	var now_window_hight = get_viewport().get_visible_rect().size.y#获取现在屏幕的高
	if now_window_hight!=window_hight:#如果屏幕的高改变了
		window_hight=now_window_hight#重新设置屏幕高度
		set_mouse_icon()#重新设置鼠标图标


func mouse_can_click() -> void:#如果这个项目可以被点击时调用
	selectable=true#设置鼠标为可点击
	set_mouse_icon()#重新设置鼠标图标

func mouse_can_not_click() -> void:#如果这个项目不能再被点击时调用
	selectable=false#设置鼠标为不可点击
	set_mouse_icon()#重新设置鼠标图标
