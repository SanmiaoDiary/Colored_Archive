extends Camera2D
@export var camera_speed:float = 500
#@export var camera = "Camera2D" 


func move_camera(delta):
	var move_distance = camera_speed * delta #计算下一帧应该移动多少距离
	var direction := Vector2.ZERO #初始化向量变量
	if Input.is_action_pressed("w_down"):
		direction.y -= 1
	if Input.is_action_pressed("s_down"):
		direction.y += 1
	if Input.is_action_pressed("a_down"):
		direction.x -= 1
	if Input.is_action_pressed("d_down"):
		direction.x += 1
		
	direction = direction.normalized()#让斜着移动的时候速度也为1
	position += direction * move_distance#把值赋给位置这个变量，让节点移动	
func _process(delta: float) -> void:
	move_camera(delta)
