class_name ObsidianNode
extends CharacterBody2D

@export var radius: int = 20
@export var connected_nodes: Array[ObsidianNode] = []
@export var is_created: bool = true

@onready var node_body: CollisionShape2D = $NodeBody
@onready var area_body: CollisionShape2D = $Area2D/AreaBody

var _hovering: bool = false
var _dragging: bool = false
var _hover_tween: Tween
var _default_color: Color

func _ready() -> void:
	Globals.gravity_disabled.connect(_on_gravity_disabled)
	Globals.node_hover.connect(_handle_hover_state_change)
	node_body.shape.radius = radius
	area_body.shape.radius = radius
	if is_created:
		_default_color = Colors.normal_color
	else:
		_default_color = Colors.muted_color

func _process(delta: float) -> void:
	if _dragging:
		global_position = get_global_mouse_position()
		
func _on_gravity_disabled()-> void:
	print("ObsidianNode::_on_gravity_disabled")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") and _hovering:
			_dragging = true
		elif event.is_action_released("left_mouse") and _hovering:
			_dragging = false

func _on_mouse_entered() -> void:
	if not _dragging:
		_hovering = true
		if _hover_tween and _hover_tween.is_running():
			_hover_tween.kill()
		_hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		_hover_tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.5)
		$Sprite2D.self_modulate = Colors.accent_color
		Globals.node_hover.emit(true)


func _on_mouse_exited() -> void:
	if not _dragging:
		_hovering = false
		if _hover_tween and _hover_tween.is_running():
			_hover_tween.kill()
		_hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		_hover_tween.tween_property(self, "scale", Vector2.ONE, 0.55)
		$Sprite2D.self_modulate = _default_color
		Globals.node_hover.emit(false)
		

func _handle_hover_state_change(is_hovering: bool):
	if _hovering:
		return 
	if is_hovering:
		_default_color.a = .5
	else:
		_default_color.a = 1.0
	$Sprite2D.self_modulate = _default_color
