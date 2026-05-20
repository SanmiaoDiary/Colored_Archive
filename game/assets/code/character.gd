extends CharacterBody2D

var be_selected
var mouse_in_character
var all_characters = {0:"cat",
					1001:""}
var all_characters_speed = {0:150,
					1001:160} 
var id = 0#测试先用0
var have_characters = []#现在已经在这局游戏里面的角色
#var mouse_pos #鼠标点击后的位置/角色的目的地
var speed #角色的速度

@onready var navigation_agent2D := $NavigationAgent2D#实例化导航节点
@export var navigation_region2D: NavigationRegion2D   # 导出一个节点引用  # 根据你的实际路径调整

func _ready() -> void:#初始化
	speed = all_characters_speed[id]#获取角色的速度
	navigation_agent2D.max_speed = speed
	#navigation_agent2D.speed = speed#给导航角色的速度
	navigation_agent2D.avoidance_enabled = true#打开动态避障
	navigation_agent2D.radius = 15.0 #设置碰撞箱大小
	
	# 等待一帧，确保所有节点都已就绪
	await get_tree().physics_frame
	
	# 获取导航区域的地图 RID
	var map_rid = navigation_region2D.get_navigation_map()
	# 手动将地图设置给导航代理
	navigation_agent2D.set_navigation_map(map_rid)

	
func _physics_process(delta: float) -> void:#每帧更新(物理)
	if not navigation_agent2D.is_navigation_finished():#如果还没有到达目标地
		var next_point = navigation_agent2D.get_next_path_position()#获取下一个目标点
		var direction = (next_point - global_position).normalized()#设置位置
		velocity = direction * speed#计算速度
		move_and_slide() #自动导航
	else:#如果到达了终点
		velocity = Vector2.ZERO#设置速度为0
		move_and_slide() #自动导航
	
func _on_mouse_mouse_entered() -> void:#如果鼠标放在角色上
	mouse_in_character = true#把鼠标在角色上设为true

func _on_mouse_mouse_exited() -> void:#如果鼠标没有放在角色上
	mouse_in_character = false#把鼠标在角色上设为false

func _unhandled_input(event):#检测角色有没有被选中，当角色被选中且鼠标指定目的地时返回鼠标坐标
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:#如果按下了鼠标左键
		if mouse_in_character:#如果鼠标在角色上
			if be_selected:#如果角色被选中
				be_selected = false
				$"character selection box".hide()#隐藏角色被选中框
			else:
				be_selected = true
				$"character selection box".show()#显示角色被选中框
		else	:#如果鼠标不在角色上
			if be_selected:#如果角色被选中
				navigation_agent2D.target_position = get_global_mouse_position()#告诉导航系统目的地
