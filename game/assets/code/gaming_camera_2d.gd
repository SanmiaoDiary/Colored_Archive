extends Camera2D

@export var camera_speed:float = 500 #摄像机移动速度
@export var camera_zoom_speed:float = 5 #摄像机缩放速度
@export var camera_zoom_max:Vector2 = Vector2(4,4)#最大缩放大小
@export var camera_zoom_min:Vector2 = Vector2(0.2,0.2)#最小缩放大小
@export var camera_default_location = Vector2(500, 800)#相机默认位置
@export var map: Node2D#在检查器面板里面添加地图节点属性
@export var max_fps = 120 #最大帧率

enum all_vsync_mode{ #枚举所有的垂直同步模式
	DISABLED,#关闭
	ENABLED,#启动
	ADAPTIVE,#自适应模式
	MAILBOX#快速同步模式
}
@export var vsync_mode : all_vsync_mode = all_vsync_mode.DISABLED:#垂直同步模式
	set(value):#当变量的值被修改时
		vsync_mode = value #把vsync_mode设置成对应的值
		set_vsync_mode(vsync_mode) #应用用户设置的垂直同步模式
#@export var camera = "Camera2D" #设置默认相机

#垂直同步管理
func set_vsync_mode(will_set_vsync_mode):#设置垂直同步模式
	match will_set_vsync_mode:#根据传入的will_set_vsync_mode选择对应的垂直同步模式
		all_vsync_mode.DISABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		all_vsync_mode.ENABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		all_vsync_mode.ADAPTIVE:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		all_vsync_mode.MAILBOX:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
			
func get_now_vsync_mode():#获取现在的垂直同步模式
		return DisplayServer.window_get_vsync_mode()#返回现在的垂直同步模式

#视角移动管理	
func move_camera(delta):#移动视角函数
	var move_distance = camera_speed * delta #计算下一帧应该移动多少距离
	var speed_direction := Vector2.ZERO #初始化向量变量
	if Input.is_action_pressed("w_down"):
		speed_direction.y -= 1
	if Input.is_action_pressed("s_down"):
		speed_direction.y += 1
	if Input.is_action_pressed("a_down"):
		speed_direction.x -= 1
	if Input.is_action_pressed("d_down"):
		speed_direction.x += 1
	speed_direction = speed_direction.normalized()#让斜着移动的时候速度也为1
	#设定相机限制范围
	position += speed_direction * move_distance#把值赋给位置这个变量，让节点移动	

func camera_zoom(delta):#缩放函数
	var zoom_distance = camera_zoom_speed * delta #计算下一帧应该缩放多大
	var zoom_vector := Vector2.ZERO #初始化缩放向量
	if Input.is_action_just_pressed("zoom_in"):#放大
		zoom_vector.x += 1 * zoom_distance
		zoom_vector.y += 1 * zoom_distance
	if Input.is_action_just_pressed("zoom_out"):#缩小
		zoom_vector.x -= 1 * zoom_distance
		zoom_vector.y -= 1 * zoom_distance
	
	zoom += zoom_vector#设置缩放大小 
	#限制缩放大小
	zoom = zoom.clamp(camera_zoom_min,camera_zoom_max)
		
func _ready() -> void:
	#显示初始化
	set_vsync_mode(vsync_mode)#设置垂直同步模式 
	Engine.max_fps = max_fps#设置最大帧率
	#相机初始化
	zoom = Vector2(1,1)#初始化缩放大小
	enabled = true#激活相机
	make_current()#设置相机为聆听点
	map.get_boundaries()#运行获取地图边界函数
	position = camera_default_location#初始化相机位置
	#地图限制初始化
	limit_enabled = true#启用地图边界限制
	limit_top = map.get_boundaries().top_limit #上方限制
	limit_bottom = map.get_boundaries().bottom_limit #下方限制
	limit_left = map.get_boundaries().left_limit #左限制
	limit_right = map.get_boundaries().right_limit #右限制
	
func _process(delta: float) -> void:
	move_camera(delta)#调用移动相机函数
	camera_zoom(delta)#调用相机缩放函数
