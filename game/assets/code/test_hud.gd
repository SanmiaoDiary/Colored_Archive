extends Control

func show_test_HUD():#显示调试HUD
	visible = true

func hide_test_HUD():#隐藏调试HUD
	visible = false

func _ready() -> void:#初始化
	#隐藏调试HUD
	hide_test_HUD()
	
func _process(delta: float) -> void:
	#帧率显示
	var FPS = str(int(Engine.get_frames_per_second()))#获取实时帧数
	$"FPS".text = "FPS:" + FPS#显示帧数
	#调试HUD的开关
	if Input.is_action_just_pressed("F3_down"):#如果F3被按下
		if visible == false:
			show_test_HUD()#显示调试HUD
		else:
			hide_test_HUD()#隐藏调试HUD
