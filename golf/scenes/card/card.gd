class_name Card
extends Button

@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var max_offset_shadow: float = 50.0

var tween_hover: Tween
var tween_rot: Tween

@onready var card_texture: TextureRect = $CardTexture
@onready var shadow: TextureRect = $Shadow
@onready var drag_and_drop: DragAndDrop = $DragAndDrop

func _ready() -> void:
	# Convert to radians because lerp_angle is using that
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)

func _process(delta: float) -> void:
	if drag_and_drop.dragging:
		_reset_rotation()
	handle_shadow(delta)

func handle_shadow(_delta) -> void:
	var center: Vector2 = get_viewport_rect().size / 2
	var dist: float = global_position.x - center.x
	shadow.position.x = lerp(0.0, -sign(dist) * max_offset_shadow, abs(dist/(center.x)))

func _on_gui_input(event: InputEvent) -> void:
	drag_and_drop._handle_gui_input(event)
	if drag_and_drop.dragging: return
	if not event is InputEventMouseMotion: return
	var mouse_pos: Vector2 = get_local_mouse_position()
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)
	
func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2,1.2), 0.5)

func _reset_rotation() -> void:
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot",0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot",0.0, 0.5)

func _on_mouse_exited() -> void:
	_reset_rotation()
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)

func reset_position(starting_position: Vector2) -> void:
	global_position = starting_position
