extends CanvasLayer

var mission_time:int#定义任务时间

func _ready() -> void:#初始化
	pass
	
func _on_main_start_a_game(mission_countdown) -> void:
	mission_time = mission_countdown	#读取任务时间
	$"mission countdown/show mission countdown/mission countdown Timer".wait_time = mission_countdown#给计时器设置任务时间
	$"mission countdown/show mission countdown/mission countdown Timer".start()#启动计时器
	
func _process(delta: float) -> void:
	var FPS = str(int(Engine.get_frames_per_second()))#获取实时帧数
	$"show FPS".text = "FPS:" + FPS#显示帧数
	var mission_countdown_min = int($"mission countdown/show mission countdown/mission countdown Timer".time_left / 60.0)
	var mission_countdown_sec = int($"mission countdown/show mission countdown/mission countdown Timer".time_left) % 60
	var show_mission_countdown = "%02d:%02d" % [mission_countdown_min, mission_countdown_sec]
	$"mission countdown/show mission countdown".text = show_mission_countdown
	
