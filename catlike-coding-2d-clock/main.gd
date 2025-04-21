extends Node2D

@export var clock_prefab: PackedScene = preload("res://clock/clock.tscn")
@export var clock_radius := 128.0
@export_group("Clock Instances")
@export var time_scale_min := -10.0
@export var time_scale_max := 10.0

func _ready() -> void:
	var window_size := get_window().size
	($Bottom as Node2D).position.y = window_size.y + 2.0 * clock_radius
	var ground := $Ground as Node2D
	ground.position = Vector2(
			0.5 * window_size.x,
			window_size.y + 0.5 * clock_radius
	)
	ground.scale = Vector2(window_size.x, clock_radius)

func _on_bottom_body_entered(body):
	body.queue_free()

func _on_spawn_timer_timeout() -> void:
	var window_size := get_window().size
	print(window_size)
	var clock := clock_prefab.instantiate() as Clock
	clock.start_time = Clock.StartTimeMode.RANDOM_TIME
	clock.time_scale = randf_range(time_scale_min, time_scale_max)
	clock.position = Vector2(
			randf_range(clock_radius, get_window().size.x - clock_radius),
			-3.0 * clock_radius
	)
	add_child(clock)
