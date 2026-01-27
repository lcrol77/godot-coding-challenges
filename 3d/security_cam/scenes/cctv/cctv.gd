extends Node3D

@export var max_angle_deg := 15.0
@export var speed := 1.0  # oscillations per second
@onready var plane: MeshInstance3D = $Plane

var _time := 0.0

func _process(delta):
	_time += delta
	
	var angle = sin(_time * TAU * speed) * deg_to_rad(max_angle_deg)
	plane.rotation.y = angle
