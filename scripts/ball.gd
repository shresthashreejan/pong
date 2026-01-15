extends CharacterBody2D

@export var radius := 4
@export var color := Color.WHITE

const SPEED = 500.0

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)

func _ready() -> void:
	queue_redraw()
	velocity = Vector2(-SPEED, 0)

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var normal = collision.get_normal()
		velocity = velocity.bounce(normal)