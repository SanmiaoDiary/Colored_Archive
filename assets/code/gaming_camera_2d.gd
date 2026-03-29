extends Camera2D

@export var camera_speed:float = 500 #摄像机移动速度
@export var camera_zoom_speed:float = 5 #摄像机缩放速度
@export var camera_zoom_max:Vector2 = Vector2(4,4)#最大缩放大小
@export var camera_zoom_min:Vector2 = Vector2(0.2,0.2)#最小缩放大小
@export var map: Node2D#在检查器面板里面添加地图节点属性

#@export var camera = "Camera2D" 

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
	zoom = Vector2(1,1)#初始化缩放大小
	enabled = true#激活相机
	make_current()#设置相机为聆听点
	map.get_boundaries()#运行获取地图边界函数
	position = Vector2(500, 1000)#初始化相机位置
	
	limit_enabled = true#启用地图边界限制
	limit_top = map.get_boundaries().top_limit
	limit_bottom = map.get_boundaries().bottom_limit
	limit_left = map.get_boundaries().left_limit
	limit_right = map.get_boundaries().right_limit
	
func _process(delta: float) -> void:
	move_camera(delta)#调用移动相机函数
	camera_zoom(delta)#调用相机缩放函数
