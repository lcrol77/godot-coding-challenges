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
	target.gui_input.connect(_handle_gui_input)

func _process(delta: float) -> void:
	if dragging and target:
		var mouse_pos: Vector2 = target.get_global_mouse_position()
		target.global_position = mouse_pos - (target.size/2)

func _handle_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	if dragging:
		dragging = false
	else:
		dragging = true
