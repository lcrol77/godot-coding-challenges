class_name Dots
extends Node2D

@export var number_dots: int = 100
@export var dot_prefab: PackedScene = preload("res://dot/dot.tscn")
@export var line_width: float = 1.0
@export var max_distance: float = 100.0
@export var line_color: Color = Color("#ffffffff")

func _ready() -> void:
	randomize()
	for i in range(number_dots):
		var new_dot: Dot = dot_prefab.instantiate()
		var offset = new_dot.get_node("DotBody").shape.radius
		new_dot.position = Vector2(
			int(randf_range(0 + offset,get_viewport_rect().size.x- offset )),
			int(randf_range(0+offset,get_viewport_rect().size.y-offset))
		)
		new_dot.detection_radius = max_distance
		$DotsContainer.add_child(new_dot)
		
	
func _draw() -> void:
	for dot: Dot in $DotsContainer.get_children():
		if dot.close_dots.size() == 0: continue
		for close_dot in dot.close_dots:
			var dist = abs(dot.position.distance_to(close_dot.position))
			line_color.a = lerp(1.0, 0.0, 1/(max_distance/dist))
			draw_line(dot.position, close_dot.position, line_color, line_width, true)

func _process(delta: float) -> void:
	queue_redraw()
