@tool
class_name Card
extends Node3D

signal play_card(card: Card)
signal play_canceled(card: Card) #TODO: Implemente me!

const HOVER_OFFSET := 0.025
const NORMAL_COLOR := Color("ffffff")
const HOVER_COLOR := Color("cd883b")

@export var target_position: Vector3
@export var target_rotation: Vector3
@export var transform_speed := 12.0

@onready var card_mesh: MeshInstance3D = $CardMesh


func _process(delta: float) -> void:
	global_position = global_position.lerp(
		target_position,
		1.0 - exp(-transform_speed * delta)
		)
	global_rotation.x = lerp_angle(global_rotation.x, target_rotation.x,
		1.0 - exp(-transform_speed * delta)
		)
	global_rotation.y = lerp_angle(global_rotation.y, target_rotation.y,
		1.0 - exp(-transform_speed * delta)
		)
	global_rotation.z = lerp_angle(global_rotation.z, target_rotation.z,
		1.0 - exp(-transform_speed * delta)
		)
		
func _on_area_3d_mouse_entered() -> void:
	set_color(HOVER_COLOR)
	
func _on_area_3d_mouse_exited() -> void:
	set_color(NORMAL_COLOR)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action("accept"):
		play_card.emit(self)

func set_color(c: Color) -> void:
	var mat := card_mesh.get_active_material(0) as StandardMaterial3D
	if mat == null:
		return
	# avoid editing a shared resource
	mat = mat.duplicate()
	card_mesh.set_surface_override_material(0, mat)
	mat.albedo_color = c
