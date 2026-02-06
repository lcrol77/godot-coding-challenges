class_name CardManager
extends Node3D

@export var state_chart: StateChart
@export var lanes: Array[Lane]

@onready var hand: Hand = $Hand

var selected_card: Card
