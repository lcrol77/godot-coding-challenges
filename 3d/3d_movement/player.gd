class_name Player extends CharacterBody3D

@export var input_smooth_speed :float= 10.0  # Higher = snappier, Lower = smoother
@export_range(0, 100) var max_speed :float= 10.0
@export_range(0, 100) var max_acc :float= 10.0
@export var _allowed_area: Rect2 = Rect2(-5, -5, 10, 10)
@export_range(0, 1) var _bounciness = 0.5

var input_vector := Vector2.ZERO
var _velocity: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	var target_input := Vector2.ZERO
	target_input.x = Input.get_axis("left", "right")
	target_input.y = Input.get_axis("down", "up")
	# this is how unity does movement out of the box, this create a smoothing effect on the movement
	input_vector = input_vector.move_toward(target_input, input_smooth_speed * delta)
	input_vector = input_vector.limit_length(1.0)
	var _desired_velocity: Vector3 = Vector3(input_vector.x, 0.0, -input_vector.y) * max_speed
	var max_speed_change = max_acc * delta
	_velocity.x = move_toward(_velocity.x, _desired_velocity.x, max_speed_change)
	_velocity.z = move_toward(_velocity.z, _desired_velocity.z, max_speed_change)
	var displacement = _velocity * delta
	var new_position = position + displacement
	if new_position.x< _allowed_area.position.x:
		new_position.x = _allowed_area.position.x
		_velocity.x = -_velocity.x * _bounciness
	elif new_position.x >= _allowed_area.end.x:
		new_position.x = _allowed_area.end.x
		_velocity.x = -_velocity.x * _bounciness
	if new_position.z< _allowed_area.position.y:
		new_position.z = _allowed_area.position.y
		_velocity.z = -_velocity.z * _bounciness
	elif new_position.z >= _allowed_area.end.y:
		new_position.z = _allowed_area.end.y
		_velocity.z = -_velocity.z * _bounciness
	position = new_position
