extends Node2D

@export var clock_prefab: PackedScene = preload("res://clock/clock.tscn")
@export var clock_radius := 128.0

func _ready() -> void:
	var window_size := get_window().size
	print(window_size)
	var clock := clock_prefab.instantiate() as Node2D
	clock.position = Vector2(
			randf_range(clock_radius, get_window().size.x - clock_radius),
			clock_radius
	)
	add_child(clock)
	($Bottom as Node2D).position.y = window_size.y + 2.0 * clock_radius
	var ground := $Ground as Node2D
	ground.position = Vector2(
			0.5 * window_size.x,
			window_size.y + 0.5 * clock_radius
	)
	ground.scale = Vector2(window_size.x, clock_radius)

func _on_bottom_body_entered(body):
	body.queue_free()
