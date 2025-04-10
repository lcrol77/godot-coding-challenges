class_name PlayerController
extends CharacterBody2D

enum JUMP_DIRECTIONS {UP = -1, DOWN = 1}

@export_range(0, 1000, 0.1) var ACCELERATION: float = 500.0
@export_range(0, 1000, 0.1) var MAX_SPEED: float = 100.0
@export_range(0, 10, 0.1) var SPRINT_MULTIPLIER: float = 1.5
@export_range(0, 1000, 0.1) var FRICTION: float = 500.0
@export_range(0, 1000, 0.1) var AIR_RESISTENCE: float = 200.0
@export_range(0, 1000, 0.1) var GRAVITY: float = 500.0
@export_range(0, 1000, 0.1) var JUMP_FORCE: float = 200.0
@export_range(0, 1000, 0.1) var JUMP_CANCEL_FORCE: float = 800.0
@export_range(0, 1000, 0.1) var WALL_SLIDE_SPEED: float = 50.0
@export_range(0, 1, 0.01) var COYOTE_TIMER: float = 0.08
@export_range(0, 1, 0.01) var JUMP_BUFFER_TIMER: float = 0.1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var jumping: bool = false

func _physics_process(delta: float) -> void:
	physics_tick(delta)

func physics_tick(delta: float) -> void:
	var inputs: Dictionary = get_inputs()
	handle_velocity(delta, inputs.input_direction)
	handle_gravity(delta)
	handle_jump_naive(delta,inputs.input_direction, inputs.jump_released, inputs.jump_released)
	process_animations()
	move_and_slide()

func handle_jump_naive(delta: float, move_direction: Vector2,jump_pressed: bool, _jump_released: bool) -> void:
	if jump_pressed:
		apply_jump(move_direction)

func apply_jump(move_direction: Vector2, jump_force: float = JUMP_FORCE, jump_direction: int = JUMP_DIRECTIONS.UP) -> void:
	jumping = true
	velocity.y += jump_force * jump_direction
	
func handle_velocity(delta: float, input_direction: Vector2) -> void:
	if input_direction.x != 0:
		apply_velocity(delta, input_direction)
	else:
		apply_friction(delta)

func apply_friction(delta: float) -> void:
	var fric: float = FRICTION * delta * sign(velocity.x) * -1 if is_on_floor() else AIR_RESISTENCE * delta * sign(velocity.x) * -1
	if abs(velocity.x) <= abs(fric):
		velocity.x = 0
	else:
		velocity.x += fric

func apply_velocity(delta: float, move_direction: Vector2) -> void:
	var sprint_strength: float = 1.0
	velocity.x += move_direction.x * ACCELERATION * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED * abs(move_direction.x) * sprint_strength, MAX_SPEED * abs(move_direction.x) * sprint_strength)

func handle_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta

func get_inputs() -> Dictionary:
	return {
		input_direction = get_input_direction(),
		jump_pressed = Input.is_action_just_pressed("jump"),
		jump_released = Input.is_action_just_released("jump"),
	}

func process_animations() -> void:
	# TODO: this up to use an enum to track which state we are in
	# currently this function is stupid to read and I hate it
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
	# note do not use jumping here as there are other cases where the char
	# may be "falling that do not incldue jumping" 
	if not is_on_floor():
		if velocity.y < 0:
			# going up
			animated_sprite_2d.play("jump_up")
		else:
			# going down
			animated_sprite_2d.play("jump_down")
	else:
		if velocity.x == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	


func get_input_direction() -> Vector2:
	var x_dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# if I want a binary movement system FOR SURE one can use sign()
	return Vector2(x_dir , y_dir)
