class_name CardManager
extends Node3D

@export var state_chart: StateChart
@export var lanes: Array[Lane]

@onready var hand: Hand = $Hand
@onready var selected_state: SelectedState = $StateMachine/Turn/SelectedState
@onready var neutral_state: NeutralState = $StateMachine/Turn/NeutralState

var selected_card: Card

func _ready() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.connect(neutral_state.card_clicked)
	for lane: Lane in lanes:
		lane.selected.connect(selected_state.play_card)
