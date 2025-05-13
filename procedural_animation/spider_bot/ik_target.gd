@tool
extends Marker3D

@export var step_target: Node3D
@export var step_distance: float = 3.0

@export var adj_leg: Node3D
@export var opp_leg: Node3D
var is_stepping: bool

func _ready() -> void:
	global_position = step_target.global_position

func _process(delta: float) -> void:
	if (abs(global_position.distance_to(step_target.global_position)) > step_distance and !adj_leg.is_stepping and !is_stepping):
		step()
		opp_leg.step()

func step():
	var target_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func(): is_stepping = false)
 
