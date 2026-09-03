# 模组加载器，管理所有的模组
extends Node

var mod:Node#当前要加载的模组
var loader_mods:Dictionary = {}#所有加载的模组

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("MODLoader_water[INFO]starting...")
	var game_dir = OS.get_executable_path().get_base_dir()#获取游戏根目录
	var dir =DirAccess.open(game_dir)#打开这个路径
	search_mods_folder(dir)#搜索mods文件夹
	load_mods(dir)#尝试在游戏启动时加载模组

func _process(delta: float) -> void:
	pass

func search_mods_folder(dir:DirAccess):#搜索mods文件夹
	if dir == null:#如果这个路径不存在
		print("MODLoader_water[ERROR]can't find game dir! permission denied\nplease check the game dir or run the game as an administrator")
		OS.alert("模组加载器_水【错误】找不到游戏目录！权限不足\n请检查游戏目录或以管理员身份运行游戏")#弹出错误提示对话框
		return#退出函数 防止崩溃
	if not dir.dir_exists("mods"):#如果mods文件夹不存在
		print("MODLoader_water[INFO]mods folder not found,try to create mods folder")
		if create_mods_folder(dir):#尝试创建mods文件夹
			print("MODLoader_water[INFO] mods folder ready")
		else:
			print("MODLoader_water[ERROR] mods folder not available, mod loading disabled")
			return
	else:#如果mods文件夹存在
		print("MODLoader_water[INFO]mods folder found")

func create_mods_folder(dir:DirAccess):#创建mods文件夹
	var return_info = dir.make_dir("mods")#尝试创建mods文件夹
	if return_info == OK:#如果创建成功
		print("MODLoader_water[INFO]create mods folder success")
		return true
	else:
		if error_string(return_info) == "Permission denied":#如果权限不足
			print("MODLoader_water[ERROR]create mods folder failed Permission denied\nplease run the game as an administrator")
			OS.alert("模组加载器_水【错误】创建mods文件夹失败！权限不足\n请以管理员身份运行游戏")#弹出失败提示对话框
		else:
			print("MODLoader_water[ERROR]create mods folder failed "+error_string(return_info))	
			OS.alert("模组加载器_水【错误】创建mods文件夹失败！错误代码："+error_string(return_info)+"\n请检查硬盘剩余空间是否充足，并尝试以管理员身份运行游戏")
		return false
	
func load_mods(dir:DirAccess):#加载模组
	pass

func reload_mods():#热加载模组
	pass

func create_new_character(name:String):#创建新角色
	pass