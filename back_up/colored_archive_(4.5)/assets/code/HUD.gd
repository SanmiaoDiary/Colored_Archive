extends Control

var mission_time:int#定义任务时间
#@onready var FPS_lable = $"test HUD/FPS"#显示fps文本节点的路径
#@onready var test_HUD = $"test HUD"#调试HUD的路径
@onready var mission_countdown_Timer_lable = $"mission countdown/show mission countdown/mission countdown Timer"#倒计时计时器器节点的路径
@onready var mission_countdown_lable = $"mission countdown/show mission countdown"#倒计时文本节点的路径

var strategic_deployment_panel_is_open=false#战略配备面板的开关情况（默认关闭）
	
func _on_main_start_a_game(mission_countdown) -> void:#在新的一局游戏开始时启动计时器
	mission_time = mission_countdown	#读取任务时间
	mission_countdown_Timer_lable.wait_time = mission_countdown#给计时器设置任务时间
	mission_countdown_Timer_lable.start()#启动计时器


func _ready() -> void:#初始化
	visible=true#默认显示
	

func _process(delta: float) -> void:
	#任务倒计时显示
	var mission_countdown_min = int(mission_countdown_Timer_lable.time_left / 60.0)
	var mission_countdown_sec = int(mission_countdown_Timer_lable.time_left) % 60
	var show_mission_countdown = "%02d:%02d" % [mission_countdown_min, mission_countdown_sec]
	mission_countdown_lable.text = show_mission_countdown
	set_HUD_visibility()#自动设置HUD可见性

func set_HUD_visibility():#设置HUD可见性
	if strategic_deployment_panel_is_open:#如果战略配备面板被打开
		visible=false#隐藏
	else: 
		visible=true#显示

func _on_strategic_deployment_strategic_deployment_is_open() -> void:#接受到战略配备面板打开的信号
	strategic_deployment_panel_is_open=true#把战略配备面板是否打开设置为真


func _on_strategic_deployment_strategic_deployment_is_close() -> void:#接受到战略配备面板关闭的信号
	strategic_deployment_panel_is_open=false#把战略配备面板是否打开设置为假
