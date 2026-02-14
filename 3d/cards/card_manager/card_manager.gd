class_name CardManager
extends Node3D

@export var state_chart: StateChart
@export var lanes: Array[Lane]
@export var plane_height: float = 3.0 ## The height of the intercetion plane. Defaults to 3.5. 3 is the height of the table in the main scene.

@onready var hand: Hand = $Hand


var selected_card: Card

func _ready() -> void:
	for lane: Lane in lanes:
		lane.selected.connect(play_card)

#region BaseState
func _on_base_state_state_entered() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.connect(card_clicked)

func _on_base_state_state_exited() -> void:
	for card: Card in get_tree().get_nodes_in_group("cards"):
		card.card_clicked.disconnect(card_clicked)

func _on_base_state_state_processing(_delta: float) -> void:
	if selected_card:
		state_chart.send_event("OnSelect")

func card_clicked(card: Card) -> void:
	var card_parent := card.get_parent()
	if card_parent is Hand:
		selected_card = card
	else:
		hand.add_card_to_hand(card)
#endregion
#region SelectedState
func _on_selected_state_state_entered() -> void:
	hand.tuck_cards()
	for lane: Lane in lanes:
		if lane.is_empty():
			lane.toggle_highlight(true)
			lane.is_clickable = true
	state_chart.send_event("OnDrag")

func _on_selected_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		handle_cancel()

func _on_selected_state_state_exited() -> void:
	pass
#endregion
#region DraggingState
func _on_dragging_state_state_entered() -> void:
	if selected_card == null:
		handle_cancel()
	selected_card.area_3d.input_ray_pickable = false

func _on_dragging_state_state_processing(_delta: float) -> void:
	var hit: Vector3 = _mouse_hit_on_drag_plane()
	if hit == null:
		return
	selected_card.global_position = hit

func _on_dragging_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		handle_cancel()
	if event.is_action_pressed("accept"):
		pass

func _mouse_hit_on_drag_plane() -> Variant:
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return null
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)
	
	var plane: Plane = Plane(Vector3.UP, plane_height)
	return plane.intersects_ray(ray_origin, ray_dir)
#endregion
#region AimingState

#endregion
#region ReleasedState
func _on_released_state_state_entered() -> void:
	state_chart.send_event("OnReleased")

func _on_released_state_state_exited() -> void:
	return_to_base_state_cleanup()
#endregion

func play_card(lane: Lane)-> void:
	assert(selected_card != null, "Cannot play, selected card is null")
	lane.add_card_to_lane(selected_card)
	state_chart.send_event("OnDrop")

func handle_cancel() -> void:
	return_to_base_state_cleanup()
	state_chart.send_event("OnCancel")

func return_to_base_state_cleanup() -> void:
	for lane: Lane in lanes:
		lane.toggle_highlight(false)
		lane.is_clickable = false
	if selected_card:
		selected_card.area_3d.input_ray_pickable = true
	selected_card = null
	hand.untuck_cards()
