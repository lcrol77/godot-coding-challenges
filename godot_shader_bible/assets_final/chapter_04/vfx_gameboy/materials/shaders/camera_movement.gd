extends Camera3D

@export var mouse_sensitivity: float = 0.2
@export var move_speed: float = 5.0
@export var sprint_multiplier: float = 2.0

var yaw: float = 0.0
var pitch: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_look(event)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_mouse_look(event: InputEventMouseMotion) -> void:
	yaw   -= event.relative.x * mouse_sensitivity
	pitch -= event.relative.y * mouse_sensitivity

	pitch = clamp(pitch, -89.0, 89.0)
	rotation_degrees = Vector3(pitch, yaw, 0.0)

func _handle_movement(delta: float) -> void:
	var velocity := Vector3.ZERO

	# Forward / Backward
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("ui_up"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("move_backward") or Input.is_action_pressed("ui_down"):
		velocity += transform.basis.z

	# Left / Right
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		velocity += transform.basis.x

	if velocity != Vector3.ZERO:
		velocity = velocity.normalized()

	var speed := move_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier

	#Uncomment this to debug:
	if velocity != Vector3.ZERO:
		print("Moving with velocity: ", velocity)

	position += velocity * speed * delta
