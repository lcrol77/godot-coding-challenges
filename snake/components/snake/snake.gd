extends Area2D

@export var step_size: int = 20
@export var move_delay: float = 0.1  # Time (in seconds) between moves
@onready var body: Node = $Body

enum CardinalDirection {
	HORIZ, VERT
}

const SNAKE_BODY = preload("res://components/snake/snakeBody/snake_body.tscn")
var target_position: Vector2
var direction: Vector2 = Vector2.DOWN
var curr_cardnal_direction: CardinalDirection = CardinalDirection.VERT
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
	var new_direction: CardinalDirection
	var horizontal = Input.is_action_pressed("right") or Input.is_action_pressed("left")
	var vertical = Input.is_action_pressed("up") or Input.is_action_pressed("down")
	match true:
		horizontal:
			new_direction = CardinalDirection.HORIZ
		vertical:
			new_direction = CardinalDirection.VERT

	if input_direction != Vector2.ZERO and new_direction != curr_cardnal_direction:
		direction = input_direction
		if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
			direction.y = 0
			curr_cardnal_direction = CardinalDirection.HORIZ
		elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
			direction.x = 0
			curr_cardnal_direction = CardinalDirection.VERT
		
	direction = direction.normalized()
	
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
		
