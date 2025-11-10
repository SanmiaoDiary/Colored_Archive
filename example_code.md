# 示例代码
## 1.自定义鼠标光标
有两种方法来自定义鼠标光标
1. 在项目设置里面来设置鼠标指针的图片  
   点击项目-项目设置 会弹出一个窗口在窗口里面选中显示-鼠标指针 在里面就可以改鼠标的样式了
2. 使用代码
	```GDscript
	var arrow = load("res://arrow.png")#先在这里定义一个变量 让Godot知道这个鼠标的图片文件在哪里
	var beam = load("res://beam.png")
	Input.set_custom_mouse_cursor(arrow)#这个是常规的定义鼠标样式的方法
	Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)#这个是把鼠标改成I形状的方法
	```
## 2. 判断玩家是否按下了某一个键
这个要分两种情况一种是需要一直检测是不是按下的，还有一种是判断是不是按下了（只检测一次）  
第一种情况适合用键盘上的wasd移动玩家  
第二种情况适合类RTS的移动，只关心鼠标是不是按下了
1. 检测玩家是否按住了某键
	```GDscript
	if Input.is_key_pressed(KEY_W):#需要注意的是KEY_W需要提前在项目设置的输入映射里面设置
	```
2. 检测玩家是否点击某键
	```GDscript
	func mouse_button_down(event):
		if event is InputEventMouseButton and event.pressed and event.button == MOUSE_BUTTON_LEFT:#跟python很像对吧
	```
## 3. 使用代码来实例化角色（添加角色）
1. 创建角色场景
	1. 先按场景-创建场景 来创建一个场景
	2. 在场景里面添加根节点 节点名字叫CharacterBody2D方便我们之后用代码控制它
	3. 再在根节点下添加一个Sprite2D作为它的贴图
	4. 再在根节点下添加一个CollisionShape2D作为它的碰撞箱
	5. 再点击CollisionShape2D给它绘制碰撞箱
	1. 然后在按ctrl+s保存 命名为character.tscn
2. 编写代码
	1. 确保你有一个main.tscn场景
	2. 把character.tscn拖到main.tscn里面来实例化它（这还没完）
	3. 给main添加一个脚本
	4. 在脚本里面添加代码
		```GDscript
		extends Node2D

		# ① 把角色场景提前加载好，只加载一次
		const UNIT_SCENE = preload("res://Unit.tscn")

		func _input(event): # 输入事件                      # 每按一下键就刷一个，方便测试
			if event is InputEventKey and event.pressed and event.keycode == KEY_F:
				spawn_unit()

		func spawn_unit():#实例化角色
			# ② 实例化
			var unit = UNIT_SCENE.instantiate()
			# ③ 放到场景里
			add_child(unit)
		
		func spawn_unit():#随机生成一个角色
			var unit = UNIT_SCENE.instantiate()
			unit.global_position = Vector2(randf_range(100, 700), randf_range(100, 500))
			add_child(unit)
		```
