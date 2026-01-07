class_name Player
extends Node3D

var rolling := false
@export var rotation_time := 0.25
@export var size := 1.0  # cube edge length in world units
@export var debug_marker := true

@onready var marker: Node3D = $Marker

var _start_t: Transform3D
var _pivot: Vector3
var _axis: Vector3
var _angle := 0.0

func _process(_delta: float) -> void:
	if rolling:
		return

	# Use just_pressed so you don't enqueue multiple rolls per key hold
	if Input.is_action_just_pressed("ui_up"):
		roll(Vector3.FORWARD)
	elif Input.is_action_just_pressed("ui_down"):
		roll(Vector3.BACK)
	elif Input.is_action_just_pressed("ui_left"):
		roll(Vector3.LEFT)
	elif Input.is_action_just_pressed("ui_right"):
		roll(Vector3.RIGHT)

func roll(dir: Vector3) -> void:
	rolling = true
	dir = dir.normalized()

	var half := size * 0.5

	_start_t = global_transform
	_pivot = _start_t.origin + (Vector3.DOWN * half) + (dir * half)
	_axis  = Vector3.UP.cross(dir).normalized()
	
	_angle = PI * 0.5

	if debug_marker:
		marker.global_position = _pivot

	var tween := get_tree().create_tween()
	tween.tween_method(_apply_roll_t, 0.0, 1.0, rotation_time)
	tween.finished.connect(func(): rolling = false)

func _apply_roll_t(t: float) -> void:
	var rot := Basis(_axis, _angle * t)

	var origin := _start_t.origin
	var rotated_origin := _pivot + (rot * (_start_t.origin - _pivot))
	var rotated_basis := rot * _start_t.basis

	global_transform = Transform3D(rotated_basis, rotated_origin)
