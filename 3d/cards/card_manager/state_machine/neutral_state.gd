class_name NeutralState extends BaseState


func _on_neutral_state_state_processing(_delta: float) -> void:
	if card_manager.selected_card:
		card_manager.state_chart.send_event("OnSelect")

func card_clicked(card: Card) -> void:
	var card_parent := card.get_parent()
	if card_parent is Hand:
		card_manager.selected_card = card
	else:
		card_manager.hand.add_card_to_hand(card)

func _on_neutral_state_state_entered() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.connect(card_clicked)

func _on_neutral_state_state_exited() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.disconnect(card_clicked)
