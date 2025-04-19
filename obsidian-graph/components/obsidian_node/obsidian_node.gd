class_name ObsidianNode
extends CharacterBody2D

@export var radius: int = 20

@onready var node_body = $NodeBody

var connected_nodes: Array[ObsidianNode] = []

func _ready() -> void:
	node_body.shape.radius = radius

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)

func _process(delta: float) -> void:
	queue_redraw()
