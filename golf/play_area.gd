class_name PlayArea
extends Node

@export var card_prefab: PackedScene = preload("res://scenes/card/card.tscn")

@onready var middle_top: Node2D = $MiddleTop
@onready var middle_bottom: Node2D = $MiddleBottom
@onready var right_top: Node2D = $RightTop
@onready var right_bottom: Node2D = $RightBottom
@onready var left_top: Node2D = $LeftTop
@onready var left_bottom: Node2D = $LeftBottom

func _ready() -> void:
	#TODO: include code to set where the play nodes are
	for child in get_children():
		var new_card: Card = card_prefab.instantiate()
		child.add_child(new_card)
		new_card.position -= (new_card.size / 2)
		setup_card(new_card)
		
func setup_card(card: Card) -> void: 	
	card.drag_and_drop.drag_started.connect(_on_card_drag_started.bind(card))
	card.drag_and_drop.drag_canceled.connect(_on_card_drag_canceled.bind(card))
	card.drag_and_drop.dropped.connect(_on_card_dropped.bind(card))

func _move_card(card: Card, new_pos: Node2D) -> void:
	card.global_position = new_pos.global_position - (card.size / 2)
	card.reparent(new_pos)

func _on_card_drag_started(card: Card) -> void:
	pass

func _on_card_drag_canceled(starting_pos: Vector2, card: Card) -> void:
	card.reset_position(starting_pos)

func _on_card_dropped(starting_pos: Vector2, card: Card) -> void:
	pass
