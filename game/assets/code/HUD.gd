extends CanvasLayer

var mission_time:int#定义任务时间
@onready var FPS_lable = $"test HUD/FPS"#显示fps文本节点的路径
@onready var test_HUD = $"test HUD"#调试HUD的路径
@onready var mission_countdown_Timer_lable = $"mission countdown/show mission countdown/mission countdown Timer"#倒计时计时器器节点的路径
@onready var mission_countdown_lable = $"mission countdown/show mission countdown"#倒计时文本节点的路径

	
func _on_main_start_a_game(mission_countdown) -> void:#在新的一局游戏开始时启动计时器
	mission_time = mission_countdown	#读取任务时间
	mission_countdown_Timer_lable.wait_time = mission_countdown#给计时器设置任务时间
	mission_countdown_Timer_lable.start()#启动计时器

func show_test_HUD():#显示调试HUD
	test_HUD.visible = true

func hide_test_HUD():#隐藏调试HUD
	test_HUD.visible = false

func _ready() -> void:#初始化
	#隐藏调试HUD
	hide_test_HUD()

func _process(delta: float) -> void:
	#帧率显示
	var FPS = str(int(Engine.get_frames_per_second()))#获取实时帧数
	FPS_lable.text = "FPS:" + FPS#显示帧数
	
	#任务倒计时显示
	var mission_countdown_min = int(mission_countdown_Timer_lable.time_left / 60.0)
	var mission_countdown_sec = int(mission_countdown_Timer_lable.time_left) % 60
	var show_mission_countdown = "%02d:%02d" % [mission_countdown_min, mission_countdown_sec]
	mission_countdown_lable.text = show_mission_countdown
	#调试HUD的开关
	if Input.is_action_just_pressed("F3_down"):#如果F3被按下
		if test_HUD.visible == false:
			show_test_HUD()
		else:
			hide_test_HUD()
