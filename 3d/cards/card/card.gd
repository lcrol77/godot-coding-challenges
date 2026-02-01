class_name Card
extends Node3D

const HOVER_OFFSET := 0.025
const NORMAL_COLOR := Color("ffffff")
const HOVER_COLOR := Color("cd883b")

var hover_tween: Tween
var origin_pos: Vector3

@onready var card_mesh: MeshInstance3D = $CardMesh


func _ready() -> void:
	origin_pos = global_position

func _on_area_3d_mouse_entered() -> void:
	set_color(HOVER_COLOR)
	
func _on_area_3d_mouse_exited() -> void:
	set_color(NORMAL_COLOR)
	
func _hover(is_hovered: bool) -> void:
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()

	var p := origin_pos
	if is_hovered:
		p.y += HOVER_OFFSET

	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	hover_tween.tween_property(self, "global_position", p, 0.2)

func set_color(c: Color) -> void:
	var mat := card_mesh.get_active_material(0) as StandardMaterial3D
	if mat == null:
		return
	# avoid editing a shared resource
	mat = mat.duplicate()
	card_mesh.set_surface_override_material(0, mat)
	mat.albedo_color = c
