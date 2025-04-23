class_name ObsidianNodeMananger
extends Node2D

@export var node_prefab: PackedScene 

func _ready():
	var new_node = node_prefab.instantiate()
	add_child(new_node)
	new_node.position = get_viewport_rect().size / 3
