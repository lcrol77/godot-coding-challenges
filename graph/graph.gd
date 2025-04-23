extends Node3D

@export var point_prefab: PackedScene
@export var number_points: int = 10



func _ready() -> void:
	var position_vec = Vector3.ZERO;
	var scale_vec = Vector3.ONE / 5.0;
	for i in range(number_points):
		var point: Node3D = point_prefab.instantiate()
		add_child(point)
		position_vec.x = (((i as float) + .5) / 5.0 - 1.0)
		point.position = position_vec
		point.scale = scale_vec
