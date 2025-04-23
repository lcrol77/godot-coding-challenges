extends Node3D

@export var point_prefab: PackedScene
@export var number_points: int = 10

func _ready() -> void:
	for i in range(number_points):
		var point: Node3D = point_prefab.instantiate()
		add_child(point)
		point.position = Vector3.RIGHT * (((i as float) + .5) / 5.0 - 1.0)
		point.scale = Vector3.ONE / 5
