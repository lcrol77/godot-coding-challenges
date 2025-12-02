class_name Player 
extends Node3D

var rolling: bool = false
var rotation_time: float = .25
var size = 1.0

@onready var marker: CSGSphere3D = $Marker


func _process(_delta: float) -> void:
	if rolling:
		return
	# Movement input
	if Input.is_action_pressed("ui_up"):
		roll(Vector3.FORWARD)
	if Input.is_action_pressed("ui_down"):
		roll(Vector3.BACK)
	if Input.is_action_pressed("ui_left"):
		roll(Vector3.LEFT)
	if Input.is_action_pressed("ui_right"):
		roll(Vector3.RIGHT)

func roll(dir: Vector3) -> void:
	rolling = true
	
	var pivot:Vector3 = global_transform.origin + Vector3(dir.x * .5, -.5, dir.z * .5)
	marker.global_position = pivot
	
	var axis:Vector3 = pivot.cross(dir).normalized()
	var rot = transform.basis.rotated(axis, PI/2)
	var start_q := Quaternion(transform.basis)
	var end_q := Quaternion(rot)

	var tween = get_tree().create_tween()
	tween.tween_method(apply_quat, start_q, end_q, rotation_time)
	tween.finished.connect(func(): rolling  = false)

func apply_quat(q: Quaternion) -> void:
	transform.basis = Basis(q)
