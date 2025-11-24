class_name Player 
extends CharacterBody3D

var rolling: bool = false
var rotation_time: float = .25
var size = 1.0


func _physics_process(delta: float) -> void:
	# Movement input
	if Input.is_action_pressed("ui_up"):
		roll(Vector3.FORWARD, delta)
	if Input.is_action_pressed("ui_down"):
		roll(Vector3.BACK,delta)
	if Input.is_action_pressed("ui_left"):
		roll(Vector3.LEFT,delta)
	if Input.is_action_pressed("ui_right"):
		roll(Vector3.RIGHT,delta)

func roll(direction: Vector3, delta):
	rolling = true
	rotate_object_local(direction, delta)
