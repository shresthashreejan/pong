extends CharacterBody2D

const SPEED := 600.0

func get_y_dir() -> float:
	return Input.get_action_strength('down') - Input.get_action_strength('up')

func _physics_process(delta: float) -> void:
	var dir : Vector2 = Vector2(0, get_y_dir())
	velocity = dir * SPEED
	move_and_slide()