@tool
class_name Card
extends Node3D

signal card_clicked(card: Card)

const HOVER_OFFSET := 0.025
const NORMAL_COLOR := Color("ffffff")
const HOVER_COLOR := Color("cd883b")

@export var transform_speed := 12.0

@onready var card_mesh: MeshInstance3D = $CardMesh
@onready var area_3d: Area3D = $CardMesh/Area3D

func _on_area_3d_mouse_entered() -> void:
	set_color(HOVER_COLOR)
	
func _on_area_3d_mouse_exited() -> void:
	set_color(NORMAL_COLOR)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("accept"):
		card_clicked.emit(self)

func set_color(c: Color) -> void:
	var mat := card_mesh.get_active_material(0) as StandardMaterial3D
	if mat == null:
		return
	# avoid editing a shared resource
	mat = mat.duplicate()
	card_mesh.set_surface_override_material(0, mat)
	mat.albedo_color = c
