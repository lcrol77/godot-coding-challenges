extends Area2D

@export var step_size: int = 20
@export var move_delay: float = 0.1  # Time (in seconds) between moves
@onready var body: Node = $Body

const SNAKE_BODY = preload("res://components/snake/snakeBody/snake_body.tscn")
var target_position: Vector2
var direction: Vector2 = Vector2.DOWN
# this is the direction that is being "processed on this physics step"
var curr_physics_direction: Vector2 = direction
var time_since_last_move: float = 0.0
var last_pos: Vector2


func _ready() -> void:
	target_position = global_position

func _physics_process(delta):
	time_since_last_move += delta
	if time_since_last_move >= move_delay:
		last_pos = global_position
		target_position = global_position + (direction * step_size)
		curr_physics_direction = direction
		global_position = target_position
		Events.grid_add.emit(self)
		time_since_last_move = 0.0
		for child: SnakeBody in body.get_children():
			var tmp_pos: Vector2 = child.global_position
			child.global_position = last_pos
			child.enabled = true
			last_pos = tmp_pos
			Events.grid_add.emit(child)
		Events.grid_remove.emit(last_pos)

func _process(_delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	# FIXME: game current will allow you to cycle through vert -> horiz -> vert without actually
	# applying a direction update in _physics_process. This can cause the game to think that it 
	# applied the correct logic but it didn't.
	if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
		input_direction.y = 0
	elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
		input_direction.x = 0
	input_direction = input_direction.normalized()
	if _input_direction_valid(input_direction):
		direction = input_direction

func _input_direction_valid(input_direction) -> bool:
	return (input_direction.x != 0 and curr_physics_direction.x == 0) or (input_direction.y != 0 and curr_physics_direction.y == 0)

func _add_snake_body(snake_body: SnakeBody) -> void:
	body.add_child(snake_body)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("apple"):
		area.call_deferred("queue_free")
		for i in range(10):
			var snake_body: SnakeBody = SNAKE_BODY.instantiate()
			snake_body.global_position = global_position
			snake_body.enabled = false
			call_deferred("_add_snake_body", snake_body)
		Events.apple_eaten.emit()
	elif area.is_in_group("body"):
		var curr_body: SnakeBody = area
		if curr_body.enabled:
			Events.game_over.emit()
		
