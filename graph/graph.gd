@tool
extends Node3D

@export var point_prefab: PackedScene
@export var points_container: Node3D
@export var function: FunctionLibrary.FunctionName
@export_range(10,100) var resolution: int = 10

var time: float = 0.0
var points: Array[CSGBox3D]

func _ready() -> void:
	var _step: float = 2.0 / (resolution as float)
	var _position = Vector3.ZERO;
	var _scale = Vector3.ONE * _step;
	points = []
	var x = 0
	var z = 0
	for i in range(resolution * resolution):
		if x == resolution:
			x = 0
			z+=1
		var point: CSGBox3D = point_prefab.instantiate()
		points_container.add_child(point)
		_position.x = (((x as float) + .5) * _step - 1.0)
		_position.z = (((z as float) + .5) * _step - 1.0)
		point.position = _position
		point.scale = _scale
		point.material.set_shader_parameter("worldPos", _position)
		points.append(point)
		x += 1

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var f: Callable = FunctionLibrary.get_function(function)
	time += delta
	for point: Node3D in points:
		var pos: Vector3 = point.position
		pos.y = f.call(pos.x, pos.z, time)
		point.position = pos
