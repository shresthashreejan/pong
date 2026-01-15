extends Node2D

@export var camera : Camera2D
@export var wall_thickness := 12.0

@onready var top = $Top/CollisionShape2D
@onready var bottom = $Bottom/CollisionShape2D
@onready var left = $Left/CollisionShape2D
@onready var right = $Right/CollisionShape2D

func _ready() -> void:
	update_bounds()

func update_bounds():
	if not camera:
		return

	var viewport_size = camera.get_viewport_rect().size
	var zoom = camera.zoom

	var size = viewport_size / zoom
	var center = camera.global_position

	top.shape = RectangleShape2D.new()
	top.shape.size = Vector2(size.x, wall_thickness)
	top.global_position = center + Vector2(0, -size.y / 2 - wall_thickness / 2)

	bottom.shape = RectangleShape2D.new()
	bottom.shape.size = Vector2(size.x, wall_thickness)
	bottom.global_position = center + Vector2(0, size.y / 2 + wall_thickness / 2)

	left.shape = RectangleShape2D.new()
	left.shape.size = Vector2(wall_thickness, size.y)
	left.global_position = center + Vector2(-size.x / 2 - wall_thickness / 2, 0)

	right.shape = RectangleShape2D.new()
	right.shape.size = Vector2(wall_thickness, size.y)
	right.global_position = center + Vector2(size.x / 2 + wall_thickness / 2, 0)
