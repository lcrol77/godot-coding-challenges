class_name Attractor
extends Area2D

@export var circ_radius: float = 10.0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape_2d.shape.radius = circ_radius
