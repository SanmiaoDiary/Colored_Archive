extends TileMapLayer

func get_boundaries() -> Dictionary:#获取地图边界
	var tile_width = tile_set.tile_size.x           # 单个瓦片宽度（像素）
	var tile_height = tile_set.tile_size.y			#单个瓦片高度
	var tile_size = get_used_rect()
	var map_width_tile_num = tile_size.size.x   # 地图的宽上有几个瓦片
	var map_height_tile_num = tile_size.size.y   # 地图的高上有几个瓦片
	print(tile_size.size.x,tile_size.size.y)
	print(map_height_tile_num,map_width_tile_num)
	#计算限制范围
	var top_limit = 0 #上边界
	var bottom_limit = map_height_tile_num * tile_height #下边界
	var left_limit = 0 #左边界
	var right_limit = map_width_tile_num * tile_width #右边界
	return {
		"top_limit":top_limit,
		"bottom_limit":bottom_limit,
		"left_limit":left_limit,
		"right_limit":right_limit
		}
func _ready() -> void:
	pass
