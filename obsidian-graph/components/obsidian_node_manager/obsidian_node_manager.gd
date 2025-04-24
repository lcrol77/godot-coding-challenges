@tool
class_name ObsidianNodeMananger
extends Node2D

@export var node_prefab: PackedScene 

var _default_color: Color = Globals.muted_color
func _ready():
	Globals.node_hover.connect(_handle_hover_state_change)
	queue_redraw()

func _draw() -> void:
	for child: ObsidianNode in get_children():
		if child.connected_nodes.size() == 0: continue
		for connected_node: ObsidianNode in child.connected_nodes:
			if connected_node == null: continue
			if child._hovering:
				draw_line(child.position, connected_node.position, Globals.accent_color, -1, true)
			else:
				draw_line(child.position, connected_node.position, _default_color, -1, true)

func _process(delta: float) -> void:
	queue_redraw()

func _handle_hover_state_change(is_hovering: bool): 
	if is_hovering:
		_default_color.a = .5
	else:
		_default_color.a = 1.0
