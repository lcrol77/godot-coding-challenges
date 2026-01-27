@tool
class_name Trail3D extends MeshInstance3D

var _points = []
var _widths = []
var _lifePoints = []

@export var _trailEnabled : bool = true ## Is trail allowed to be shown
@export var _fromWidth : float = 0.5 ## Starting width of the trail
@export var _toWidth : float = 0.5 ## Ending width of the trail 
@export_range(0.5,1.5) var _scaleAcceleration : float = 1.0 ## Speed of the scaling

@export var _motionDetla : float = 0.1 ## Sets the smoothness of the trail, how long it will take for a new trail piece to be made
@export var _lifeSpan : float = 1.0 ## Sets the durration until this part of the trail is no longer used, and is thus removed

@export var _startColor : Color = Color(1.0,1.0,1.0,1.0)
@export var _endColor : Color = Color(1.0,1.0,1.0,0.0)

var _oldPos : Vector3 # Get the previous position

func _ready() -> void:
	_oldPos = get_global_transform().origin
	mesh = ImmediateMesh.new()

func _process(delta: float) -> void:
	if(_oldPos - get_global_transform().origin).length() > _motionDetla  and _trailEnabled:
		append_point()
		_oldPos = get_global_transform().origin
	var p = 0
	var max_points = _points.size()
	while p < max_points:
		_lifePoints[p] += delta
		if _lifePoints[p] > _lifeSpan:
			remove_point(p)
			p -= 1
			if p < 0: p = 0
		max_points = _points.size()
		p+=1
	mesh.clear_surfaces()
	if _points.size() < 2:
		return
	var angle_step = 15
	var num_circle_verts = int(360 / angle_step) + 1  # +1 to close the circle

	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	for i in range(_points.size() - 1):  # loop through ring pairs
		var t0 = float(i) / (_points.size() - 1)
		var t1 = float(i + 1) / (_points.size() - 1)

		var color0 = _startColor.lerp(_endColor, 1 - t0)
		var color1 = _startColor.lerp(_endColor, 1 - t1)

		var width0 = _widths[i][0] - pow(1 - t0, _scaleAcceleration) * _widths[i][1]
		var width1 = _widths[i+1][0] - pow(1 - t1, _scaleAcceleration) * _widths[i+1][1]

		for theta in range(0, 361, angle_step):  # full circle
			var rad = deg_to_rad(theta)
			var angle_fraction = float(theta) / 360.0

			var v0 = to_local(_calc_circ_val_from_point(_points[i], rad, width0.x))
			var v1 = to_local(_calc_circ_val_from_point(_points[i + 1], rad, width1.x))

			# Vertex from ring i
			mesh.surface_set_color(color0)
			mesh.surface_set_uv(Vector2(t0, angle_fraction))
			mesh.surface_add_vertex(v0)

			# Vertex from ring i + 1
			mesh.surface_set_color(color1)
			mesh.surface_set_uv(Vector2(t1, angle_fraction))
			mesh.surface_add_vertex(v1)
	mesh.surface_end()


func _calc_circ_val_from_point(mid_point: Vector3, theta: float, r: float) -> Vector3:
	return Vector3(mid_point.x+ r*cos(theta),mid_point.y, mid_point.z + r*sin(theta))

func append_point()-> void:
	_points.append(get_global_transform().origin)
	_widths.append([
		get_global_transform().basis.x * _fromWidth,
		get_global_transform().basis.x * _fromWidth - get_global_transform().basis.x * _toWidth,
	])
	_lifePoints.append(0.0)

func remove_point(i: int)-> void:
	_points.remove_at(i)
	_widths.remove_at(i)
	_lifePoints.remove_at(i)
