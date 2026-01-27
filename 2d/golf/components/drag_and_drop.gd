class_name DragAndDrop
extends Node

signal drag_started
signal drag_canceled(starting_position: Vector2)
signal dropped(starting_position: Vector2)

@export var enabled: bool = true
@export var target: Control 

var starting_position: Vector2
var dragging: bool = false

func _ready() -> void:
	assert(target, "No target set for DragAndDrop Component")
	
func _process(delta: float) -> void:
	if dragging and target:
		target.global_position = target.get_global_mouse_position() - (target.size/2)

func _handle_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and not dragging:
		starting_position = target.global_position
		dragging = true
		drag_started.emit()
	elif event.is_action_pressed("select") and dragging:
		dragging = false
		dropped.emit(starting_position)
	elif event.is_action_pressed("cancel"):
		dragging = false
		drag_canceled.emit(starting_position)
	
