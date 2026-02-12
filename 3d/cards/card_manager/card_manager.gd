class_name CardManager
extends Node3D

@export var state_chart: StateChart
@export var lanes: Array[Lane]

@onready var hand: Hand = $Hand

var selected_card: Card

#region BaseState
func _on_base_state_state_entered() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.connect(card_clicked)

func _on_base_state_state_exited() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.disconnect(card_clicked)

func _on_base_state_state_processing(_delta: float) -> void:
	if selected_card:
		state_chart.send_event("OnSelect")

func card_clicked(card: Card) -> void:
	var card_parent := card.get_parent()
	if card_parent is Hand:
		selected_card = card
	else:
		hand.add_card_to_hand(card)
#endregion
#region SelectedState
func _on_selected_state_state_entered() -> void:
	hand.tuck_cards()
	for lane: Lane in lanes:
		#lane.selected.connect(play_card)
		if lane.is_empty():
			lane.toggle_highlight(true)
	state_chart.send_event("OnDrag")

func _on_selected_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		selected_card = null
		hand.untuck_cards()
		state_chart.send_event("OnCancel")

func _on_selected_state_state_exited() -> void:
	#for lane: Lane in lanes:
		#lane.selected.disconnect(play_card)
		#lane.toggle_highlight(false)
	#selected_card = null
	#hand.untuck_cards()
	pass
#endregion
#region DraggingState
func _on_dragging_state_state_entered() -> void:
	pass

func _on_dragging_state_state_processing(_delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	print(mouse_position)
	selected_card.global_position = Vector3(mouse_position.x, selected_card.global_position.y, mouse_position.y)

func _on_dragging_state_state_exited() -> void:
	pass # Replace with function body.

func _on_dragging_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		selected_card = null
		hand.untuck_cards()
		state_chart.send_event("OnCancel")

#endregion
#region AimingState

#endregion
#region ReleasedState
#endregion

func play_card(lane: Lane)-> void:
	lane.add_card_to_lane(selected_card)
	state_chart.send_event("OnPlay")
