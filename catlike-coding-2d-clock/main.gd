extends Node2D

@export var clock_prefab: PackedScene = preload("res://clock/clock.tscn")
@export var clock_radius := 128.0

func _ready() -> void:
	var clock := clock_prefab.instantiate() as Node2D
	clock.position = Vector2(
			randf_range(clock_radius, get_window().size.x - clock_radius),
			clock_radius
	)
	add_child(clock)
	($Bottom as Node2D).position.y = get_window().size.y


func _on_bottom_body_entered(body):
	body.queue_free()
