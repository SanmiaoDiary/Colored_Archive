#战略配备按钮的脚本
extends TextureButton
#----定义战略配备按钮类----
class strategic_deployment_buttons extends TextureButton:#控制实例的类
	var manager#管理器节点的名称
	
	var select_mode = false#是否被选中

	@onready var tween:Tween = null#初始化tween

	var init_position:Vector2#按钮初始位置
	var showed_position:Vector2#按钮运动后的位置
	
	var strategic_deployment_name#战略配备名称
	var cd#冷却时间
	var icon#图标
	var id#战略配备id
	
	func _init(manager,id,name,cd,button_position,button_icon) -> void:#初始化示例
		self.manager=manager#赋值管理器
		self.id=id#赋值id
		strategic_deployment_name=name#赋值名称
		self.cd=cd#赋值cd
		init_position=button_position#设置按钮初始位置防止重叠
		showed_position = init_position + Vector2(10,0)#设置按钮运动后的位置
		icon=load(button_icon)#把图标赋值给变量
		
		
		
	func _ready() -> void:#实例启动时
		pressed.connect(_on_pressed)#连接信号到pressed
		position = init_position#初始化按钮的位置
		mouse_entered.connect(_on_mouse_entered)#连接信号告诉鼠标节点鼠标这个东西可以点
		mouse_exited.connect(_on_mouse_exited)#连接信号告诉鼠标节点鼠标这个东西不能点
		visible = true#显示按钮
		texture_normal=icon#设置按钮的默认纹理
		texture_pressed=icon#设置按钮被按下时的纹理
		texture_hover=icon#设置鼠标悬停在按钮上时按钮的纹理
		texture_disabled=icon#禁用状态时显示的纹理
		texture_focused=icon#持有鼠标或键盘焦点时覆盖在基础纹理上的纹理

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
			select_mode = true#设置按钮现在被选中了
			
	func cancel_select():#取消选中时
		if select_mode == false:#如果已经显示就什么也不干
			return
		else:
			if tween and tween.is_running():#如果有正在运行的动画就终止它避免重复
				tween.kill()#删除已经在运行的tween实例
			visible = true#显示面板
			tween = create_tween()#创建动画
			#播放动画（使按钮轻微下浮）
			tween.tween_property(self,"position",init_position,0.1)\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_OUT)
			select_mode = false#设置按钮现在没有被选中了

	func _on_pressed() -> void:#处理按钮选中相关事件的函数(已连接到信号pressed)
			manager.control_button_only_one_can_select(id)#向管理器请求被选中
				
	func _on_mouse_entered():
		Mouse.mouse_can_click()#调用全局单例设置鼠标为可点击

	func _on_mouse_exited():
		Mouse.mouse_can_not_click()#调用全局单例设置鼠标为不可点击
#----管理按钮实例----
@onready var father_node=get_parent()#获取父节点
var all_strategic_deployment = DataManager.all_strategic_deployment#从数据管理器处获得全部的战略配备字典
var all_strategic_deployment_dict={}#保存所有战略配备名称的字典，用于区分各个实例
var now_beselect#现在被按下的按钮
var new_beselect#新的被按下的按钮

func create_button():#创建所有的按钮
	var strategic_deployment_id#战略配备id
	var strategic_deployment_data#战略配备信息
	var new_button#临时保存新实例的变量
	var button_index = 0#按钮索引
	var button_position:Vector2#按钮的位置
	#var butthon_size:Vector2=Vector2(64,64)#设置按钮的大小
	
	
	#创建所有的战略配备实例
	for key in all_strategic_deployment:#遍历字典的键
		strategic_deployment_id = key#保存key作为战略配备的id
		strategic_deployment_data=all_strategic_deployment[key]#获取当前这个战略配备的信息
		button_position=Vector2(20,95+button_index*(size.y+20))#计算按钮位置
		new_button=strategic_deployment_buttons.new(self,strategic_deployment_id,strategic_deployment_data["name"],strategic_deployment_data["cd"],button_position,strategic_deployment_data["icon"])#实例化按钮
		father_node.add_child.call_deferred(new_button)#把实例添加到节点树
		all_strategic_deployment_dict[key]=new_button#把key添加到战略配备字典里面方便管理
		button_index+=1#让索引每次循环结束后自动加一

func delete_button():
	for value in all_strategic_deployment_dict.values():#遍历字典
		if is_instance_valid(value):#检查是否有这个实例
			value.queue_free()#安全的删除所有的实例
	all_strategic_deployment_dict.clear()#清除这个字典里面的所有内容
	
func control_button_only_one_can_select(buttonid):#控制按钮同时只能按下一个
	new_beselect=buttonid#设置新的被按下的按钮
	if new_beselect!=now_beselect:#如果这是新被按下的按钮
		for key in all_strategic_deployment_dict:#遍历字典寻找之前被选中的按钮
			if key==now_beselect:#去找之前这个已经被选中的按钮
				all_strategic_deployment_dict[key].cancel_select()#取消之前被选中的按钮的选中状态
		for key in all_strategic_deployment_dict:#遍历字典寻找现在被选中的按钮
			if key==new_beselect:#去找现在这个已经被选中的按钮
				all_strategic_deployment_dict[key].be_selected()#让这个新的按钮被选中
				now_beselect=new_beselect#设置这个按钮为当前被选中的按钮
				new_beselect=null#现在没有新的按钮被选中了
	else:#如果这个按钮就是现在这个被按下的按钮就让它取消选中
		for key in all_strategic_deployment_dict:#找到这个按钮
			all_strategic_deployment_dict[key].cancel_select()#取消选中这个按钮
		
		
func _ready() -> void:
	visible = false#设置可见性为否，隐藏本体
	size=Vector2(64,64)#设置按钮大小
	delete_button()#删除所有的按钮，初始化按钮字典
	create_button()#创建所有的新按钮实例

func _process(delta: float) -> void:
	pass
	
