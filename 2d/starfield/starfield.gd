class_name Starfield
extends Node2D

@export var number_stars: int = 100
@onready var stars: Node = $Stars
@onready var camera_2d: Camera2D = $Camera2D


const STAR = preload("res://star.tscn")
var view_port_size: Vector2 

func _ready() -> void:
	for i in range(number_stars):
		var new_star := STAR.instantiate()
		stars.add_child(new_star)
