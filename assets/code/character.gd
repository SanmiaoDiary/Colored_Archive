extends CharacterBody2D

var be_selected
var mouse_in_character
var all_characters = {0:"cat",
					1001:""}
var all_characters_speed = {0:150,
					1001:160} 
var id = 0#测试先用0
var have_characters = []#现在已经在这局游戏里面的角色
var mouse_pos
var speed

func _ready() -> void:#初始化
	speed = all_characters_speed[id]#获取角色的速度
	
func _process(delta: float) -> void:#每帧更新
	if be_selected and mouse_pos != null:#如果角色被选中而且有目的地
		var target = mouse_pos#获取目的地
		var direction = (target - position).normalized()#计算方向
		var step = direction * speed * delta
		if step.length() > position.distance_to(target):
			position = target
			mouse_pos = null
		else:
			position += step
	
func _on_mouse_mouse_entered() -> void:#如果鼠标放在角色上
	mouse_in_character = true#把鼠标在角色上设为true

func _on_mouse_mouse_exited() -> void:#如果鼠标没有放在角色上
	mouse_in_character = false#把鼠标在角色上设为false

func _unhandled_input(event):#检测角色有没有被选中，当角色被选中且鼠标指定目的地时返回鼠标坐标
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:#如果按下了鼠标
		if mouse_in_character:#如果鼠标在角色上
			if be_selected:#如果角色被选中
				be_selected = false
				$"character selection box".hide()#隐藏角色被选中框
			else:
				be_selected = true
				$"character selection box".show()#显示角色被选中框
		else	:#如果鼠标不在角色上
			if be_selected:#如果角色被选中
				mouse_pos = get_global_mouse_position()#存储鼠标在的位置方便后面移动角色
				be_selected = false#开始运动时取消角色的被选中状态
