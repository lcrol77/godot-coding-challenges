class_name ObsidianNode
extends RigidBody2D

@export var radius: int = 20

@onready var node_body = $NodeBody

var _acceleration: Vector2

var connected_nodes: Array[ObsidianNode] = []

func _ready() -> void:
	node_body.shape.radius = radius
	
func _physics_process(delta: float) -> void:
	print(linear_velocity)
	move_and_collide(linear_velocity)
