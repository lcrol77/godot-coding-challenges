class_name Dot
extends CharacterBody2D

@export var speed := 100
@export var radius: float = 5
var detection_radius: float: set = _set_detection_radius

var close_dots: Array[Dot] = []

func _ready() -> void:
	$DotBody.shape.radius = radius
	$DetectionArea/CollisionShape2D.shape.radius = detection_radius
	rotation_degrees = randf_range(0,360.0)
	velocity = -transform.y * speed

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)

func _process(delta: float) -> void:
	queue_redraw()

func _set_detection_radius(val: float) -> void:
	detection_radius = val
	$DetectionArea/CollisionShape2D.shape.radius = detection_radius
	

func _physics_process(delta: float) -> void:
	var collison := move_and_collide(velocity * delta)
	if not collison: return
	velocity = velocity.bounce(collison.get_normal())

func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Dot: return
	close_dots.append(area.get_parent())

func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is not Dot: return
	close_dots.erase(area.get_parent())
