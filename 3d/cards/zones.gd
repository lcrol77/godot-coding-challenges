class_name Zones
extends Node3D

@onready var hand: Hand = $Hand
@onready var lane: Lane = $Lanes/Lane

var lanes: Array = [lane]

func _ready() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.play_card.connect(play_card)

func play_card(_card: Card) -> void:
	hand.tuck_cards()
	for curr: Lane in lanes:
		if lane.is_empty():
			lane.toggle_highlight(true)
	
