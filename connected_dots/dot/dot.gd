class_name dot
extends CharacterBody2D

var radius: float = 20.0

func _ready() -> void:
	pass

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.RED)

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	pass
