class_name SkinController
extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_animation(anim: String) -> void:
	animation_player.play(anim)
