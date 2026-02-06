class_name BaseState extends Node

var card_manager : CardManager

func _ready() -> void:
	if %StateMachine and %StateMachine is CardManagerStateMachine:
		card_manager = %StateMachine.card_manager
