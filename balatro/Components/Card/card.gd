class_name Card
extends Button

var tween_hover: Tween
var following_mouse: bool = false

func _process(delta: float) -> void:
	follow_mouse(delta)

func follow_mouse(_delta: float) ->void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size/2)


func _on_gui_input(event: InputEvent) -> void:
	handle_mouse_click(event)

func handle_mouse_click(event) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	if following_mouse:
		following_mouse = false
	else:
		following_mouse = true


func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2,1.2), 0.5)

func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
