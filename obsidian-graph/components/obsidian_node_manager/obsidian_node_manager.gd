class_name ObsidianNodeMananger
extends Node2D

@export var node_prefab: PackedScene 

func _ready():
	pass

func _draw() -> void:
	for child: ObsidianNode in get_children():
		if child.connected_nodes.size() == 0: continue
		for connected_node: ObsidianNode in child.connected_nodes:
			draw_line(child.position, connected_node.position, Color(1,1,1,.5))

func _process(delta: float) -> void:
	queue_redraw()
