@tool
class_name Hand
extends Node3D

const CARD := preload("res://card/card.tscn")

@export var height_curve: Curve
@export var width_curve: Curve
@export var rotation_curve: Curve
@export var hand_width = .75


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_card"):
		var new_card: Card = CARD.instantiate()
		add_child(new_card)

func sort_hand() -> void:
	for card: Card in get_children():
		var hand_ratio: float = 0.5
		if get_child_count() > 1:
			hand_ratio = float(card.get_index()) / float(get_child_count() - 1)
		var offset = Vector3.ZERO
		offset.x += width_curve.sample(hand_ratio) * get_hand_width()
		offset.y += height_curve.sample(hand_ratio)
		offset.z += card.get_index() * 0.1
		card.position = position + basis * offset
		card.rotation = global_rotation.rotated(
			Vector3.FORWARD, 
			deg_to_rad(rotation_curve.sample(hand_ratio))
			)

func get_hand_width() -> float:
	match get_child_count():
		2:
			return 0.15
		3:
			return 0.25
		4:
			return 0.5
		_:
			return 0.75


func _on_child_entered_tree(_node: Node) -> void:
	sort_hand()
