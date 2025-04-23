class_name ObsidianNode
extends RigidBody2D

@export var radius: int = 20
@export var connected_nodes: Array[ObsidianNode] = []

@onready var node_body = $NodeBody

var _hovering: bool = false
var _following_mouse: bool = false

func _ready() -> void:
	Globals.gravity_disabled.connect(_on_gravity_disabled)
	node_body.shape.radius = radius

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)

func _process(delta: float) -> void:
	if _following_mouse:
		global_position = get_global_mouse_position()
	queue_redraw()

func _on_gravity_disabled()-> void:
	print("ObsidianNode::_on_gravity_disabled")
	linear_damp = 10.0

func _on_mouse_entered() -> void:
	_hovering = true

func _on_mouse_exited() -> void:
	print("_on_mouse_exited")
	_hovering = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") and _hovering:
			_following_mouse = true
		elif event.is_action_released("left_mouse") and _hovering:
			print("asdfasdf")
			_following_mouse = false
