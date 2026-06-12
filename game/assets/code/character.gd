extends CharacterBody2D

class character extends CharacterBody2D:#角色类 方便管理多个角色
	@onready var navigation_agent2D := $NavigationAgent2D#实例化导航节点
	@export var navigation_region2D: NavigationRegion2D#导出一个节点引用
	
	var be_selected#角色是否被选中
	var mouse_in_character#鼠标是否在角色上
	var all_characters=DataManager.all_characters#从角色管理器里面拿到保存有所有角色的字典
	var id = 0#测试先用0
	var have_characters = {}#现在已经在这局游戏里面的角色的字典
	var speed #角色的速度
	var hp#角色的血量
	
	func _init(id:String,position:Vector2,scale:Vector2) -> void:
		self.id=id#赋值id
		self.position=position#赋值位置
		self.scale=scale#赋值缩放
		for key in all_characters:#递归寻找id对应的key
			if key==id:#如果找到了对应的key
				speed=all_characters[key][speed]#给角色赋值上字典里面写好的对应的key
				hp=all_characters[key][hp]#给角色赋值上对应的血量
				
	class state_machine:#状态机类 管理所有的状态
		class selection extends state_machine:#选中类 控制角色是否被选中
			class selected:#选中类 控制角色被选中
				pass
			class not_selected:#没有被选中类 控制角色取消被选中
				pass
		class action:#动作类 控制角色做的动作
			class moving:#移动类 控制角色移动
				var parent_class:character#引用父类
				var speed:float=parent_class.speed#定义速度
				var navigation_agent2D:NavigationAgent2D=parent_class.navigation_agent2D#定义navigation_agent2D
				var navigation_region2D:NavigationRegion2D=parent_class.navigation_region2D#定义navigation_region2D
				func _init() -> void:
					pass
				func _ready() -> void:#初始化
					speed = parent_class.speed#获取角色的速度
					navigation_agent2D.max_speed = speed#给导航角色的最大速度
					navigation_agent2D.avoidance_enabled = true#打开动态避障
					navigation_agent2D.radius = 15.0 #设置碰撞箱大小
					
					await parent_class.get_tree().physics_frame# 等待一帧，确保所有节点都已就绪
					
					var map_rid = navigation_region2D.get_navigation_map()# 获取导航区域的地图 RID
					navigation_agent2D.set_navigation_map(map_rid)# 手动将地图设置给导航代理
				
				func _physics_process(delta: float) -> void:#每帧更新(物理)
					var velocity:Vector2
					if not navigation_agent2D.is_navigation_finished():#如果还没有到达目标地
						var next_point = navigation_agent2D.get_next_path_position()#获取下一个目标点
						var direction = (next_point - parent_class.global_position).normalized()#设置位置
						velocity = direction * speed#计算速度
						parent_class.move_and_slide() #自动导航
					else:#如果到达了终点
						velocity = Vector2.ZERO#设置速度为0
						parent_class.move_and_slide() #自动导航
					
				func _on_mouse_mouse_entered() -> void:#如果鼠标放在角色上
					parent_class.mouse_in_character = true#把鼠标在角色上设为true
					Mouse.mouse_can_click()#调用全局单例设置鼠标为可点击

				func _on_mouse_mouse_exited() -> void:#如果鼠标没有放在角色上
					parent_class.mouse_in_character = false#把鼠标在角色上设为false
					Mouse.mouse_can_not_click()#调用全局单例设置鼠标为不可点击
					
				func _unhandled_input(event):#检测角色有没有被选中，当角色被选中且鼠标指定目的地时返回鼠标坐标
					if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:#如果按下了鼠标左键
						if parent_class.mouse_in_character:#如果鼠标在角色上
							if parent_class.be_selected:#如果角色被选中
								parent_class.be_selected = false
								parent_class.get_node("character selection box").hide()#隐藏角色被选中框
							else:
								parent_class.be_selected = true
								parent_class.get_node("character selection box").show()#显示角色被选中框
						else	:#如果鼠标不在角色上
							if parent_class.be_selected:#如果角色被选中
								navigation_agent2D.target_position = parent_class.get_global_mouse_position()#告诉导航系统目的地
					
			class standby:#待机类 控制角色处在待机状态
				func _ready() -> void:#初始化
					return#直接返回什么都不需要做
#----角色管理器部分----
