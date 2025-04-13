class_name Dots
extends Node2D

@export var number_dots: int = 20
@export var dot_prefab: PackedScene = preload("res://dot/dot.tscn")

func _ready() -> void:
	randomize()
	for i in range(number_dots):
		var new_dot: Dot = dot_prefab.instantiate()
		var offset = new_dot.get_node("DotBody").shape.radius
		new_dot.position = Vector2(
			int(randf_range(0 + offset,get_viewport_rect().size.x- offset )),
			int(randf_range(0+offset,get_viewport_rect().size.y-offset))
		)
		$DotsContainer.add_child(new_dot)
