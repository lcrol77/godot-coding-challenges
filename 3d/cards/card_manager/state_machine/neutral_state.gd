extends BaseState


func _on_neutral_state_state_processing(_delta: float) -> void:
	if card_manager.selected_card:
		card_manager.state_chart.send_event("OnSelect")
