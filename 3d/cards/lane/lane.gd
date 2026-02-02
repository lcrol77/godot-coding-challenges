class_name Lane
extends Node3D

signal selected(lane: Lane)

@onready var highlight: MeshInstance3D = $Highlight
@onready var card_slot: Node3D = $CardSlot

func toggle_highlight(is_vis: bool) -> void:
	print(is_vis)
	highlight.visible = is_vis

func is_empty() -> bool:
	return card_slot.get_child_count() == 0

func add_card(card: Card) -> void:
	pass


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if is_empty():
			selected.emit(self)


func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
