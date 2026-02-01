class_name Card
extends Node3D

const HOVER_OFFSET := 0.024

var hover_tween: Tween
var origin_pos: Vector3

func _ready() -> void:
	origin_pos = global_position


func _on_area_3d_mouse_entered() -> void:
	_hover(true)

func _on_area_3d_mouse_exited() -> void:
	_hover(false)

func _hover(is_hovered: bool) -> void:
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()

	var p := origin_pos
	if is_hovered:
		p.y += HOVER_OFFSET

	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	hover_tween.tween_property(self, "global_position", p, 0.2)
