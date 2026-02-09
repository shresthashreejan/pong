extends Node2D

const SCREEN_SIZE := Vector2(1280, 720)
const PADDLE_SIZE := Vector2(20, 120)
const BALL_SIZE := 16

const PADDLE_SPEED := 800
const BALL_SPEED := 800

var left_score := 0
var right_score := 0
var left_score_label: Label
var right_score_label: Label

var left_paddle: StaticBody2D
var right_paddle: StaticBody2D
var ball: CharacterBody2D
var ball_velocity := Vector2.ZERO

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	DisplayServer.window_set_size(SCREEN_SIZE)
	create_separator()
	create_walls()
	create_paddles()
	create_ball()
	reset_ball()

func create_paddles():
	left_paddle = create_paddle()
	left_paddle.position = Vector2(40, SCREEN_SIZE.y / 2)
	add_child(left_paddle)

	right_paddle = create_paddle()
	right_paddle.position = Vector2(SCREEN_SIZE.x - 40, SCREEN_SIZE.y / 2)
	add_child(right_paddle)

func create_paddle() -> StaticBody2D:
	var paddle := StaticBody2D.new()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = PADDLE_SIZE
	collision.shape = shape
	paddle.add_child(collision)

	var rect := ColorRect.new()
	rect.size = PADDLE_SIZE
	rect.color = Color.WHITE
	rect.position = -PADDLE_SIZE / 2
	paddle.add_child(rect)

	return paddle

func create_ball():
	ball = CharacterBody2D.new()

	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = BALL_SIZE / 2.0
	collision.shape = shape
	ball.add_child(collision)

	var rect := ColorRect.new()
	rect.size = Vector2(BALL_SIZE, BALL_SIZE)
	rect.color = Color.WHITE
	rect.position = Vector2(-BALL_SIZE / 2.0, -BALL_SIZE / 2.0)
	ball.add_child(rect)

	add_child(ball)

func reset_ball():
	ball.position = SCREEN_SIZE / 2
	ball_velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-0.5, 0.5)).normalized() * BALL_SPEED

func _physics_process(delta):
	handle_paddle_input(delta)
	move_ball(delta)

func handle_paddle_input(delta: float) -> void:
	var left_dir := 0
	if Input.is_key_pressed(KEY_W):
		left_dir -= 1
	if Input.is_key_pressed(KEY_S):
		left_dir += 1

	left_paddle.position.y += left_dir * PADDLE_SPEED * delta

	left_paddle.position.y = clamp(
		left_paddle.position.y,
		PADDLE_SIZE.y / 2.0,
		SCREEN_SIZE.y - PADDLE_SIZE.y / 2.0
	)

	var right_dir := 0
	if Input.is_key_pressed(KEY_UP):
		right_dir -= 1
	if Input.is_key_pressed(KEY_DOWN):
		right_dir += 1

	right_paddle.position.y += right_dir * PADDLE_SPEED * delta

	right_paddle.position.y = clamp(
		right_paddle.position.y,
		PADDLE_SIZE.y / 2.0,
		SCREEN_SIZE.y - PADDLE_SIZE.y / 2.0
	)

func move_ball(delta):
	var collision = ball.move_and_collide(ball_velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider == left_paddle:
			var offset = (ball.position.y - left_paddle.position.y) / (PADDLE_SIZE.y / 2.0)
			ball_velocity = Vector2(1, offset).normalized() * BALL_SPEED
		elif collider == right_paddle:
			var offset = (ball.position.y - right_paddle.position.y) / (PADDLE_SIZE.y / 2.0)
			ball_velocity = Vector2(-1, offset).normalized() * BALL_SPEED
		else:
			ball_velocity = ball_velocity.bounce(collision.get_normal())

	if ball.position.y < 0 or ball.position.y > SCREEN_SIZE.y:
		ball_velocity.y *= -1

	if ball.position.x < 0 or ball.position.x > SCREEN_SIZE.x:
		reset_ball()

func create_separator():
	var dash_height := 20
	var gap := 20
	var x := SCREEN_SIZE.x / 2.0 - 2

	for y in range(0, SCREEN_SIZE.y, dash_height + gap):
		var dash := ColorRect.new()
		dash.color = Color.WHITE
		dash.size = Vector2(4, dash_height)
		dash.position = Vector2(x, y)
		add_child(dash)

func create_wall(size: Vector2) -> StaticBody2D:
	var wall := StaticBody2D.new()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	wall.add_child(collision)
	return wall

func create_walls():
	var wall_width := 20

	var left_wall := create_wall(Vector2(wall_width, SCREEN_SIZE.y))
	left_wall.position = Vector2(-wall_width / 2.0, SCREEN_SIZE.y / 2.0)
	add_child(left_wall)

	var right_wall := create_wall(Vector2(wall_width, SCREEN_SIZE.y))
	right_wall.position = Vector2(SCREEN_SIZE.x + wall_width / 2.0, SCREEN_SIZE.y / 2.0)
	add_child(right_wall)