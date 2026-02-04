extends Node2D

const SCREEN_SIZE := Vector2(1280, 720)
const PADDLE_SIZE := Vector2(20, 120)
const BALL_SIZE := 16

const PADDLE_SPEED := 500
const BALL_SPEED := 400

var left_paddle: CharacterBody2D
var right_paddle: CharacterBody2D
var ball: CharacterBody2D
var ball_velocity := Vector2.ZERO

func _ready():
    DisplayServer.window_set_size(SCREEN_SIZE)
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

func create_paddle() -> CharacterBody2D:
    var paddle := CharacterBody2D.new()
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
    shape.radius = BALL_SIZE / 2
    collision.shape = shape
    ball.add_child(collision)

    var rect := ColorRect.new()
    rect.size = Vector2(BALL_SIZE, BALL_SIZE)
    rect.color = Color.WHITE
    rect.position = Vector2(-BALL_SIZE / 2, -BALL_SIZE / 2)
    ball.add_child(rect)

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

    left_paddle.velocity.y = left_dir * PADDLE_SPEED
    left_paddle.move_and_slide()

    var right_dir := 0
    if Input.is_key_pressed(KEY_W):
        right_dir -= 1
    if Input.is_key_pressed(KEY_S):
        right_dir += 1

    right_paddle.velocity.y = right_dir * PADDLE_SPEED
    right_paddle.move_and_slide()

func move_ball(delta):
    var collision = ball.move_and_collide(ball_velocity * delta)
    if collision:
        ball_velocity = ball_velocity.bounce(collision.get_normal())

    if ball.position.y < 0 or ball.position.y > SCREEN_SIZE.y:
        ball_velocity.y *= -1

    if ball.position.x < 0 or ball.position.x > SCREEN_SIZE.x:
        reset_ball()