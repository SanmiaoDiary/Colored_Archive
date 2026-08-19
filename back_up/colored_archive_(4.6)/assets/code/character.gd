extends CharacterBody2D

var all_characters=DataManager.all_characters#从角色管理器里面拿到保存有所有角色的字典
var navigation_region2D: NavigationRegion2D#导出一个节点引用

@onready var navigation_agent2D := $NavigationAgent2D#实例化导航节点
	
	
var mouse_in_character#鼠标是否在角色上
var id = ""#定义角色id
var speed #角色的速度
var hp#角色的血量
var texture#角色的贴图
	
func setup(id:String,position:Vector2,scale:Vector2,hp,speed,texture,navigation_region2D) -> void:
	self.id=id#赋值id
	self.position=position#赋值位置
	self.scale=scale#赋值缩放
	self.hp=hp#赋值血量
	self.speed=speed#赋值速度
	self.texture=texture#赋值贴图
	self.navigation_region2D=navigation_region2D#赋值navigation_region2D
	
func _ready() -> void:
	$"character texture".texture=load(self.texture)#加载角色贴图
	await move_ready()#等待移动初始化完成
	visible=true#显示角色
	
func _process(delta: float) -> void:
	state_machine()
		
var state={
	"selection":false,
	"action":"",
	"move":false
	}#定义保存所有状态的字典
	
func state_machine():#状态机函数管理所有的状态
	if state["move"]:#如果状态为移动
		move()#移动
	else:#如果状态为没有移动
		standby()#待机
		
func _unhandled_input(event):#自动根据输入更改字典里面的状态
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:#如果按下了鼠标左键
		if mouse_in_character:#如果鼠标在角色上
			if state["selection"]:#如果角色被选中
				cancel_selection()
			else:#如果角色没有被选中
				be_selection()
		else	:#如果鼠标不在角色上
			if state["selection"]:#如果角色被选中
				navigation_agent2D.target_position = get_global_mouse_position()#告诉导航系统目的地
				state["move"]=true#设置移动状态为真
					
func be_selection():#被选中函数 控制角色被选中
	state["selection"] = true#设置选中状态为是
	get_node("character selection box").show()#显示角色被选中框
		
func cancel_selection():#取消选中
	state["selection"] = false#设置选中状态为否
	get_node("character selection box").hide()#隐藏角色被选中框
	
func _on_mouse_mouse_entered() -> void:#如果鼠标放在角色上
	mouse_in_character = true#把鼠标在角色上设为true
	Mouse.mouse_can_click()#调用全局单例设置鼠标为可点击
		
func _on_mouse_mouse_exited() -> void:#如果鼠标没有放在角色上
	mouse_in_character = false#把鼠标在角色上设为false
	Mouse.mouse_can_not_click()#调用全局单例设置鼠标为不可点击
	
func move_ready():#准备移动
	navigation_agent2D.max_speed = self.speed#给导航角色的最大速度
	navigation_agent2D.avoidance_enabled = true#打开动态避障
	navigation_agent2D.radius = 15.0 #设置碰撞箱大小
					
	await get_tree().physics_frame# 等待一帧，确保所有节点都已就绪
					
	var map_rid = self.navigation_region2D.get_navigation_map()# 获取导航区域的地图 RID
	navigation_agent2D.set_navigation_map(map_rid)# 手动将地图设置给导航代理
		
func move():#移动函数
	navigation_agent2D.debug_enabled=true#打开调试模式让玩家可以看到角色的移动轨迹和目的地
	if not navigation_agent2D.is_navigation_finished():#如果还没有到达目标地
		var next_point = navigation_agent2D.get_next_path_position()#获取下一个目标点
		var direction = (next_point - global_position).normalized()#设置位置
		velocity = direction * speed#计算速度
		move_and_slide() #自动导航
	else:#如果到达了终点
		velocity = Vector2.ZERO#设置速度为0
		move_and_slide() #自动导航
		navigation_agent2D.debug_enabled=false#关闭调试模式
		state["move"]=false#设置字典，告诉状态机角色现在没有在移动
			
func standby():#待机
	return
