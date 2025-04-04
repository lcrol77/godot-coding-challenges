extends Area2D

@export var step_size: int = 20
@export var move_delay: float = 0.1  # Time (in seconds) between moves
@onready var body: Node = $Body

const SNAKE_BODY = preload("res://components/snake/snakeBody/snake_body.tscn")
var target_position: Vector2
var direction: Vector2 = Vector2.DOWN
var time_since_last_move: float = 0.0
var last_pos: Vector2

func _ready() -> void:
	target_position = global_position

func _physics_process(delta):
	time_since_last_move += delta
	if time_since_last_move >= move_delay:
		last_pos = global_position
		target_position = global_position + (direction * step_size)
		global_position = target_position
		time_since_last_move = 0.0
		for child: Area2D in body.get_children():
			var tmp_pos: Vector2 = child.global_position
			child.global_position = last_pos
			child.is_active
			last_pos = tmp_pos

func _process(delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	if input_direction != Vector2.ZERO:
		direction = input_direction
		if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
			direction.y = 0
		elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
			direction.x = 0
	direction = direction.normalized()
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("apple"):
		area.queue_free()
		for i in range(10):
			var snake_body: SnakeBody = SNAKE_BODY.instantiate()
			snake_body.global_position = global_position
			snake_body.is_active = false
			body.add_child(snake_body)
