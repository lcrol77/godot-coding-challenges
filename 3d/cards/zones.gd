class_name Zones
extends Node3D

signal lane_selected(lane: Lane)

@onready var hand: Hand = $Hand
@onready var test_lane: Lane = $Lanes/TestLane
@onready var lanes: Array = [test_lane]

func _ready() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.connect(_card_clicked)
	for lane: Lane in lanes:
		lane.selected.connect(func(node):
			lane_selected.emit(node)
		)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		cancel_play_card()

func _card_clicked(card: Card) -> void:
	var card_parent := card.get_parent()
	if card_parent is Hand:
		_play_card(card)
	else:
		_pick_up_card(card)

func cancel_play_card() -> void:
	lane_selected.emit(null)
	hand.untuck_cards()

func _play_card(card: Card)-> void:
	hand.tuck_cards()
	for lane: Lane in lanes:
		if lane.is_empty():
			lane.toggle_highlight(true)
	var lane:Lane = await lane_selected
	if lane == null:
		return
	lane.add_card_to_lane(card)
	lane.toggle_highlight(false)
	hand.untuck_cards()

func _pick_up_card(card: Card)-> void:
	hand.add_card_to_hand(card)
