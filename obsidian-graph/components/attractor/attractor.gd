class_name Attractor
extends Area2D

@export var circ_radius: float = 10.0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	Globals.gravity_disabled.connect(_disable_gravity)
	collision_shape_2d.shape.radius = circ_radius
	await get_tree().create_timer(5.0).timeout.connect(func(): Globals.gravity_disabled.emit())

func _disable_gravity() -> void:
	print("Attractor::_disable_gravity")
	gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
