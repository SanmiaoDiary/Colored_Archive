#战略配备按钮的脚本
extends TextureButton

var select_mode = false#是否被选中

@onready var tween:Tween = null#初始化tween

var init_position = Vector2(18,74)#初始位置
var showed_position = init_position - Vector2(0,10)#运动后的位置


func _ready() -> void:
	position = init_position#初始化按钮的位置

func _process(delta: float) -> void:
	pass

func be_selected():#被选中时
	if select_mode == true:#如果已经显示就什么也不干
		return
	else:
		if tween and tween.is_running():#如果有正在运行的动画就终止它避免重复
			tween.kill()#删除已经在运行的tween实例
		visible = true#显示面板
		tween = create_tween()#创建动画
		#播放动画（使按钮轻微上浮）
		tween.tween_property(self,"position",showed_position,0.1)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)

func  cancel_select():#取消选中时
	if select_mode == true:#如果已经显示就什么也不干
		return
	else:
		if tween and tween.is_running():#如果有正在运行的动画就终止它避免重复
			tween.kill()#删除已经在运行的tween实例
		visible = true#显示面板
		tween = create_tween()#创建动画
		#播放动画（使按钮轻微上浮）
		tween.tween_property(self,"position",init_position,0.1)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)

func _on_pressed() -> void:#处理按钮选中相关事件的函数(已连接到信号pressed)
	if select_mode == false:
		be_selected()
		select_mode = true
	else:
		cancel_select()
		select_mode = false
		
