class_name SelectedState extends BaseState

func _on_selected_state_state_entered() -> void:
	card_manager.hand.tuck_cards()
	for lane: Lane in card_manager.lanes:
		if lane.is_empty():
			lane.toggle_highlight(true)

func _on_selected_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		card_manager.state_chart.send_event("OnCancel")

func play_card(lane: Lane)-> void:
	lane.add_card_to_lane(card_manager.selected_card)
	card_manager.state_chart.send_event("OnPlay")

func _on_selected_state_state_exited() -> void:
	for lane: Lane in card_manager.lanes:
			lane.toggle_highlight(false)
	card_manager.selected_card = null
	card_manager.hand.untuck_cards()
	
