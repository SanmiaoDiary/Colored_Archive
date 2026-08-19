extends Node
#----角色管理器部分----
var have_characters = {}#现在已经在这局游戏里面的角色的字典
var new_character#存放新角色实例的变量
var character_index=0#存放角色在自动里面的key的变量
@onready var father_node=get_parent()#获取父节点
const CHARACTER_SCENE = preload("res://assets/scene/character.tscn")#预加载角色场景（常量）
var all_characters=DataManager.all_characters#获取所有角色的字典

@export var navigation_region2D:NavigationRegion2D#在检查器里面手动定义NavigationRegion2D节点路径

func _ready() -> void:
	for key in have_characters:#变量字典
		delete_character(key)#删除所有的字典里面的角色
	create_character("ColoredArchive.cat",Vector2(683.0,502.0),Vector2(1.0,1.0))#生成测试角色 之后再根据信号传入的角色id进行角色创建
func _process(delta: float) -> void:
	pass
	
func create_character(id:String,position:Vector2,scale:Vector2):
	var speed=all_characters[id]["speed"]#从保存所有角色数据的字典中获取速度
	var hp=all_characters[id]["hp"]#从保存所有角色数据的字典中获取血量
	var texture=all_characters[id]["texture"]#从保存所有角色数据的字典中获取角色贴图路径
	new_character=CHARACTER_SCENE.instantiate()#实例化场景
	new_character.setup(id,position,scale,hp,speed,texture,navigation_region2D)#给场景节点传递实例化类的参数
	father_node.add_child.call_deferred(new_character)#把场景节点添加到节点树
	have_characters[id]=new_character#把实例保存在字典中方便管理
	
func delete_character(id):#删除角色
	var value=have_characters[id]#取出这个实例
	if is_instance_valid(value):#检查是否有这个实例
		value.queue_free()#安全的删除这个实例
		have_characters.erase(id)#删除这个键值对
