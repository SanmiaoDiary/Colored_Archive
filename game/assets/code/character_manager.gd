extends Node
#----角色管理器部分----
var have_characters = {}#现在已经在这局游戏里面的角色的字典
var new_character#存放新角色实例的变量
@onready var father_node=get_parent()#获取父节点
const CHARACTER_SCENE = preload("res://assets/scene/character.tscn")#预加载角色场景（常量）
var all_characters=DataManager.all_characters#获取所有角色的字典

@export var navigation_region2D:NavigationRegion2D#在检查器里面手动定义NavigationRegion2D节点路径

func _ready() -> void:
	create_character("ColoredArchive.cat",Vector2(683.0,502.0),Vector2(1.0,1.0))#生成测试角色 之后再根据信号传入的角色id进行角色创建

func _process(delta: float) -> void:
	pass

var can_duplicate_creation_character_index:Dictionary={}#允许重复创建的角色的索引字典，会作为其id的一部分，用来区分同类id的可重复角色
func create_character(class_id:String,position:Vector2,scale:Vector2):#创建角色
	if all_characters.has(class_id):#如果所有角色字典里面有这个角色
		if all_characters[class_id]["duplicate_creation"]:#该角色允许重复创建吗？
			if not can_duplicate_creation_character_index.has(class_id):#如果索引字典里面没有这个角色
				can_duplicate_creation_character_index[class_id] = 0#初始化这个角色在索引字典里面的数据
			var character_id:String = class_id+"_"+str(can_duplicate_creation_character_index[class_id])#定义角色的新id
			can_duplicate_creation_character_index[class_id]+=1#迭代可重复角色字典里面的索引
			#创建角色
			new_character=CHARACTER_SCENE.instantiate()#实例化场景
			new_character.setup(
				class_id,
				character_id,
				position,
				scale,
				all_characters[class_id]["hp"],
				all_characters[class_id]["speed"],
				all_characters[class_id]["texture"],
				navigation_region2D)#给场景节点传递实例化类的参数
			father_node.add_child.call_deferred(new_character)#把场景节点添加到节点树
			#存入角色字典	
			if not have_characters.has(class_id):#如果角色字典里面没有这类角色的字典
				#在角色字典里面再建一个字典专门管理这种可重复的角色
				have_characters[class_id]={character_id:new_character}#把实例保存在字典中方便管理
			else:#如果角色字典里面已经有了这类角色的字典了
				#在角色字典里面再建一个字典专门管理这种可重复的角色
				have_characters[class_id][character_id]=new_character#把实例保存在字典中方便管理

		else:#如果角色不允许重复创建
			if have_characters.has(class_id):#游戏里面现在有这个角色了吗？
				print("ColoredArchive[ERROR] character " +class_id+" cannot be created repeatedly!")#打印错误
				return#如果有这个角色就返回
			else:#如果还没有
				new_character=CHARACTER_SCENE.instantiate()#实例化场景
				new_character.setup(
					class_id,
					class_id,
					position,
					scale,
					all_characters[class_id]["hp"],
					all_characters[class_id]["speed"],
					all_characters[class_id]["texture"],
					navigation_region2D)#给场景节点传递实例化类的参数
				father_node.add_child.call_deferred(new_character)#把场景节点添加到节点树
				have_characters[class_id]=new_character#把实例字典保存在字典中方便管理
	else:
		print("ColoredArchive[ERROR] character " +class_id+" not found!")#打印错误
		return#返回
	
func delete_character(id):#删除角色
	# 查找实例
	if "_" in id:
		var class_id = id.substr(0, id.index("_"))#取出角色类id
		var value = have_characters[class_id][id]#取出这个实例
		# 删除实例
		if is_instance_valid(value):#检查是否有这个实例
			value.queue_free()#安全的删除这个实例
			have_characters[class_id].erase(id)#删除这个键值对
		else:
			print("ColoredArchive[ERROR] character " +id+" not found in this game!")#在这个战局里面没有找到这个角色
			return#返回
		if have_characters[class_id].is_empty():#如果这个角色类字典里面没有角色了
			have_characters.erase(class_id)#删除这个空字典
	else:
		var value = have_characters[id]#取出这个实例
		# 删除实例
		if is_instance_valid(value):#检查是否有这个实例
			value.queue_free()#安全的删除这个实例
			have_characters.erase(id)#删除这个键值对
		else:
			print("ColoredArchive[ERROR] character " +id+" not found in this game!")#在这个战局里面没有找到这个角色
			return#返回

func clear_all_characters():#删除所有的角色 热重载时使用
	for key in have_characters.keys():#变量字典
		if "_" in key:#如果这个key是可重复创建的角色
			for character_id in have_characters[key]:#遍历这个角色字典
				delete_character(character_id)#删除所有的字典里面的角色
		else:
			delete_character(key)#删除所有的字典里面的角色
