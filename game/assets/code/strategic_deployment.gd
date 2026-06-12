extends Control

var is_all_strategic_deployment_show #战略配备面板正在显示吗
var init_position:Vector2 #初始化面板位置
var showed_position:Vector2 #移动后面板的位置
var window_hight #窗口的高

@onready var cost_lable = $"cost"#初始化cost节点的名字

@onready var tween:Tween = null#初始化tween

var will_show_strategic_deployment = []#将要展示的战略配备

var cost = 30000 #任务预算

signal strategic_deployment_is_open#战略配备选择面板被打开的信号
signal strategic_deployment_is_close#战略配备选择面板被关闭的信号

func _ready() -> void:
	window_hight = get_viewport().get_visible_rect().size.y#获取窗口的高
	size=Vector2(120,window_hight)#设置战略配备栏的大小
	init_position = Vector2(-120,0)#战略配备栏的初始位置 放到看不到的地方，之后再改变位置
	showed_position = init_position + Vector2(size.x,0)#战略配备栏移动后的位置，方便之后的动画使用
	position = init_position#设置面板的初始位置
	hide_all_strategic_deployment()#默认隐藏战略配备面板

	cost_lable.text = "任务预算:" + str(cost)#初始化显示任务预算的标签
	
	get_tree().root.size_changed.connect(_on_window_size_changed)#获取窗口大小改变的信号并连接到_on_window_size_changed函数
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Tab_down"):#如果按下tab键
		if is_all_strategic_deployment_show == true:#如果战略配备面板正在显示
			hide_all_strategic_deployment()#隐藏战略配备面板
			print(position)
		else:#否则
			show_all_strategic_deployment()#显示战略配备面板
			print(position)
			
func show_all_strategic_deployment():#显示战略配备面板
	if is_all_strategic_deployment_show == true:#如果已经显示就什么也不干
		return
	else:
		if tween and tween.is_running():#如果有正在运行的动画就终止它避免重复
			tween.kill()
		strategic_deployment_is_open.emit()#发射战略配备面板被打开的信号
		visible = true#显示面板
		tween = create_tween()#创建动画
		#播放动画
		tween.tween_property(self,"position",showed_position,0.1)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
		is_all_strategic_deployment_show = true

func hide_all_strategic_deployment():#隐藏战略配备面板
	if is_all_strategic_deployment_show == false:#如果已经隐藏了就什么也不干
		return
	else:
		if tween and tween.is_running():#如果有正在运行的动画就终止它避免重复
			tween.kill()
		tween = create_tween()#创建动画
		strategic_deployment_is_close.emit()#发射战略配备面板被关闭的信号
		#播放动画
		tween.tween_property(self,"position",init_position,0.1)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN)
		
		is_all_strategic_deployment_show = false
		tween.tween_callback(func(): visible = false)# 在动画链最后执行隐藏
	
func _on_window_size_changed():
	if tween and tween.is_running():#如果有正在运行的动画就终止它避免重复(防止玩家在窗口大小改变时打开/关闭战略配备面板导致鬼畜)
		tween.kill()
	window_hight = get_viewport().get_visible_rect().size.y#重新获取窗口的高
	size=Vector2(120,window_hight) 
