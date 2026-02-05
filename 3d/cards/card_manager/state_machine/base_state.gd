class_name BaseState extends Node

@export var debug : bool = false

var card_manager : CardManager


func _ready() -> void:
	if %StateMachine and %StateMachine is CardManagerStateMachine:
		card_manager = %StateMachine.card_manager
