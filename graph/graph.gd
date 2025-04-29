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
	var _scale = Vector3.ONE * _step;
	points = []
	for i in range(resolution * resolution):
		var point: CSGBox3D = point_prefab.instantiate()
		points_container.add_child(point)
		point.scale = _scale
		points.append(point)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var f: Callable = FunctionLibrary.get_function(function)
	time += delta
	var x = 0
	var z = 0
	var _step: float = 2.0 / (resolution as float)
	var v = (((z as float) + .5) * _step - 1.0)
	for point: Node3D in points:
		if x == resolution:
			x = 0
			z+=1
			v = (((z as float) + .5) * _step - 1.0)
		var u = (((x as float) + .5) * _step - 1.0)
		point.position = f.call(u, v, time)
		point.material.set_shader_parameter("worldPos", point.position)
		x +=1
