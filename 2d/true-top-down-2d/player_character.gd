extends CharacterBody2D

@export_range(0,1000) var speed := 60

func _physics_process(delta: float) -> void:
	get_player_input()
	move_and_slide()

func get_player_input() -> void:
	var vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed
