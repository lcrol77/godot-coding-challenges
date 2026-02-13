class_name Lane
extends Node3D

signal selected(lane: Lane)

@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var card_slot: Node3D = $CardSlot
@onready var highlight: MeshInstance3D = $Highlight

var is_clickable: bool = false

func toggle_highlight(is_vis: bool) -> void:
	highlight.visible = is_vis

func is_empty() -> bool:
	return card_slot.get_child_count() == 0

func add_card_to_lane(card: Card) -> void:
	# gaurd incase we get here without a card
	if card == null:
		return
	var card_parent = card.get_parent()
	card.reparent(card_slot, true)
	card.owner = self
	card.global_rotation = card_slot.global_rotation
	card.global_position = card_slot.global_position
	if card_parent.has_method("sort_hand"):
		card_parent.sort_hand()
		
func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("accept") and is_clickable:
		if is_empty():
			selected.emit(self)
			get_viewport().set_input_as_handled()

func _on_card_slot_child_entered_tree(_node: Node) -> void:
	collision_shape_3d.disabled = true

func _on_card_slot_child_exiting_tree(_node: Node) -> void:
	collision_shape_3d.disabled = false
