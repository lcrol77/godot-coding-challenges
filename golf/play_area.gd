class_name PlayArea
extends Node

@export var card_prefab: PackedScene = preload("res://components/card/card.tscn")

@onready var middle_top: Node2D = $MiddleTop
@onready var middle_bottom: Node2D = $MiddleBottom
@onready var right_top: Node2D = $RightTop
@onready var right_bottom: Node2D = $RightBottom
@onready var left_top: Node2D = $LeftTop
@onready var left_bottom: Node2D = $LeftBottom

func _random_color() -> Color:
	return Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))

func _ready() -> void:
	#TODO: include code to set where the play nodes are
	for child in get_children():
		var new_card: Card = card_prefab.instantiate()
		new_card.position -= (new_card.size /2)
		new_card.modulate = _random_color()
		child.add_child(new_card)
