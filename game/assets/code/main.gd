extends Node2D

signal start_a_game#定义开始游戏的信号

var all_map = ["grass"]#游戏里面允许拥有的所有的地图

const Character = preload("res://assets/scene/character.tscn")#加载角色场景
var character_num = 0#初始化角色数量

func _ready() -> void:
	pass

func start_game():#定义一个开始游戏的函数
	var mission_countdown = 2700#初始化任务剩余时间
	var map = all_map.pick_random() #从现有的所有地图中随机选择一个地图
	start_a_game.emit(mission_countdown,map)#发出创建一个新游戏的信号
	
func create_character():#创建一个角色
	var character = Character.instantiate()#示例化一个角色
	add_child(character)	#放到场景里
	character_num += 1#角色数量加1
	
func _process(delta: float) -> void:
	pass
