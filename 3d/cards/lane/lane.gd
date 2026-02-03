class_name Lane
extends Node3D

signal selected(lane: Lane)

@onready var highlight: MeshInstance3D = $Highlight
@onready var card_slot: Node3D = $CardSlot

func toggle_highlight(is_vis: bool) -> void:
	highlight.visible = is_vis

func is_empty() -> bool:
	return card_slot.get_child_count() == 0

func add_card(card: Card) -> void:
	var card_parent = card.get_parent()
	card.reparent(card_slot, true)
	card.owner = self
	card.global_rotation = card_slot.global_rotation
	card.global_position = card_slot.global_position
	if card_parent.has_method("sort_hand"):
		card_parent.sort_hand()
		
func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("accept"):
		if is_empty():
			selected.emit(self)

func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
