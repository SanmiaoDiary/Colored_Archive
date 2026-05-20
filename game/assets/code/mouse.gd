extends Node2D

@onready var polygon2D :=$"Polygon2D"#定义形状节点
@onready var area2D := $"Polygon2D/Area2D"#定义碰撞区域节点

func _process(delta: float) -> void:
	if polygon2D.transform != area2D.transform:
		polygon2D.transform = area2D.transform
