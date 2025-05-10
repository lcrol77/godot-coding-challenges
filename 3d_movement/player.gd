class_name Player extends CharacterBody3D

var input_vector := Vector2.ZERO
@export var input_smooth_speed :float= 10.0  # Higher = snappier, Lower = smoother
@export_range(0,100) var max_speed :float= 10.0
@export_range(0,100) var max_acc :float= 10.0

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
	position += displacement
