class_name Runner
extends CharacterBody3D

@export var lane_accel := 25.0
@export var ground_damping := 12.0
@export var move_speed := 3.0
@export var forward_speed := 5.0
@export var jump_velocity := 4.5
@export var max_tilt_deg := 30.0
@export var tilt_speed := 8.0
@export var rotate_cooldown := 0.15

@onready var skin: SkinController = $Skin
@onready var right_ray: RayCast3D = $RightRay
@onready var left_ray: RayCast3D = $LeftRay

var rotate_lock := 0.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_buffered := false
var just_transitioned: bool = false

func _ready() -> void:
	skin.set_animation("walk")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"reset_position"):
		global_position = Vector3(0, 1, 0)
		velocity = Vector3.ZERO
		reset_physics_interpolation()

	if Input.is_action_just_pressed(&"jump"):
		jump_buffered = true

func _physics_process(delta: float) -> void:
	rotate_lock = max(0.0, rotate_lock - delta)
	# Gravity
	if not is_on_floor():
		velocity += (-up_direction) * gravity * delta
	_handle_jump()
	# Horizontal control (x)
	var axis := Input.get_axis(&"move_left", &"move_right")
	_handle_movement(axis, delta)
	_handle_skin_rotation(axis, delta)
	_handle_wall_rotation(axis)
	move_and_slide()

func _rotate_90(s: int) -> void:
	var angle := deg_to_rad(90.0 * s)
	var axis_world := (-global_transform.basis.z).normalized()
	var new_up := up_direction.rotated(axis_world, angle).normalized()
	global_rotate(axis_world, angle)
	velocity = velocity.rotated(axis_world, angle)
	up_direction = new_up

func  _handle_jump() -> void:
	if jump_buffered and is_on_floor():
		velocity.y = jump_velocity
	jump_buffered = false
	

func _handle_skin_rotation(axis: float, delta:float)->void:
	var target_yaw := -deg_to_rad(axis * max_tilt_deg)
	skin.rotation.y = lerp_angle(
		skin.rotation.y,
		target_yaw,
		tilt_speed * delta
	)

func _handle_wall_rotation(axis) -> void:
	if rotate_lock <= 0.0:
		if axis > 0.0 and right_ray.is_colliding():
			_rotate_90(-1) # right turn
			rotate_lock = rotate_cooldown
		elif axis < 0.0 and left_ray.is_colliding():
			_rotate_90(1)  # left turn
			rotate_lock = rotate_cooldown

# The problem here is that I need to selectively change the vector I am writing two
# because I am sliding in the +/- X when  my up_direction is (0,1,0) and +/- Y 
# when it is (1,0,0)
func _handle_movement(axis: float, delta:float) -> void:
	var axis_of_movement := _get_current_axis_of_movement()
	var target := axis * move_speed
	velocity[axis_of_movement] += target
	velocity[axis_of_movement] *= exp(-ground_damping * delta)
	# Constant forward
	velocity.z = -forward_speed

func _get_current_axis_of_movement() -> String:
	if up_direction.x == 1 or up_direction.x == -1:
		return "y"
	if up_direction.y == 1 or up_direction.y == -1:
		return "x" 
	return "x"
