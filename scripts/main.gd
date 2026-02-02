extends Node2D

var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

func _ready():
    screen_size = get_viewport_rect().size
    pad_size = get_node("left").get_texture().get_size()
    set_process(true)