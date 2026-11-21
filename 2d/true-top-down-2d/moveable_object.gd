class_name MoveableObject
extends CharacterBody2D

@export_range(0.0,10) var drag := 5.0
@export_range(0.0, 1.0) var impact_response := 0.5
@export var initial_velocity := Vector2.ZERO

func _ready() -> void:
	velocity = initial_velocity

func _physics_process(delta: float) -> void:
	if velocity.length_squared():
		velocity *= 1.0 - (drag * delta)
		if move_and_slide():
			resolve_collisions()

func resolve_collisions() -> void:
	var curr_vel := velocity
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body = collision.get_collider() as MoveableObject
		if body:
			apply_impact(body.velocity)
			body.apply_impact(curr_vel)
		else:
			velocity -= velocity.project(collision.get_normal())


func apply_impact(impact_velocity: Vector2) -> void:
	velocity += (impact_velocity - velocity) * impact_response
