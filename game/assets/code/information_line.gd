extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible=false#设置可见性默认为不可见


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var all_info_class = {
	"info": {"Color": Color8(205, 206, 210)},
	"warn": {"Color": Color8(255, 200, 0)},
	"error": {"Color": Color8(255, 50, 50)}
}
func set_info(info_class,info):
	text=info#设置消息
	add_theme_color_override("font_color", all_info_class[info_class]["Color"])#设置样式
