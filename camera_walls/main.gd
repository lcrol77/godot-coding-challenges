class_name Main
extends Node3D

@onready var camera: Camera3D = $CamRotationPoint/Camera3D
@onready var raycast: RayCast3D = $CamRotationPoint/Camera3D/RayCast3D
@onready var cam_rotation_point: Node3D = $CamRotationPoint
@onready var player: CSGMesh3D = $Player

const camera_speed = 2

func _process(delta: float) -> void:
	if Input.is_action_pressed("down"):
		cam_rotation_point.rotation.z -= delta * camera_speed
	elif Input.is_action_pressed("up"):
		cam_rotation_point.rotation.z += delta * camera_speed
	elif Input.is_action_pressed("left"):
		cam_rotation_point.rotation.y -= delta * camera_speed
	elif Input.is_action_pressed("right"):
		cam_rotation_point.rotation.y += delta * camera_speed

func _physics_process(delta: float) -> void:
	raycast.target_position = raycast.to_local(player.global_transform.origin)
	raycast.force_raycast_update()
	if !raycast.is_colliding(): return
	var collider: Wall = raycast.get_collider()
	if !collider.is_in_group("walls"): return
	collider.cam_visible = false
