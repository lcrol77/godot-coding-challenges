class_name Mian
extends Node3D

@onready var camera_3d: Camera3D = $CamRotationPoint/Camera3D
@onready var ray_cast_3d: RayCast3D = $CamRotationPoint/Camera3D/RayCast3D
@onready var cam_rotation_point: Node3D = $CamRotationPoint

const camera_speed = 2

func _process(delta: float) -> void:
	if Input.is_action_pressed("down"):
		cam_rotation_point.rotation.z -= delta * camera_speed
	if Input.is_action_pressed("up"):
		cam_rotation_point.rotation.z += delta * camera_speed
	if Input.is_action_pressed("left"):
		cam_rotation_point.rotation.y -= delta * camera_speed
	if Input.is_action_pressed("right"):
		cam_rotation_point.rotation.y += delta * camera_speed
