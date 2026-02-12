class_name CardManager
extends Node3D

@export var state_chart: StateChart
@export var lanes: Array[Lane]
@export var use_remap_based_dragging: bool = true ## which type of dragging impolementation to use. if check it will use the remap based impl. if unchecked it will use a plane & raycast based implementation
@export var plane_height: float = 3.0 ## The height of the intercetion plane. Defaults to 3.5. 3 is the height of the table in the main scene.

@onready var hand: Hand = $Hand


var selected_card: Card

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
		#lane.selected.connect(play_card)
		if lane.is_empty():
			lane.toggle_highlight(true)
	state_chart.send_event("OnDrag")

func _on_selected_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		selected_card = null
		hand.untuck_cards()
		state_chart.send_event("OnCancel")

func _on_selected_state_state_exited() -> void:
	#for lane: Lane in lanes:
		#lane.selected.disconnect(play_card)
		#lane.toggle_highlight(false)
	#selected_card = null
	#hand.untuck_cards()
	pass
#endregion
#region DraggingState
func _on_dragging_state_state_entered() -> void:
	pass

func _on_dragging_state_state_processing(_delta: float) -> void:
	if use_remap_based_dragging:
		handle_dragging_with_remap_impl()
	else:
		handle_dragging_with_ray_cast_impl()

func _on_dragging_state_state_exited() -> void:
	pass

func _on_dragging_state_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		selected_card = null
		hand.untuck_cards()
		state_chart.send_event("OnCancel")

# essentially I need a mapping of my mouse_position wrt the viewport
# and an accepted x,z coordinates that make sense for the card in world space. 
func handle_dragging_with_remap_impl() -> void:
	var mouse_position := get_viewport().get_mouse_position()
	# the x movement feels pretty great here, y not so much
	var mapped_mouse_pos := Vector2(remap(mouse_position.x,0,1920,-5,5),remap(mouse_position.y,0,1080,-1,5))
	selected_card.global_position = Vector3(mapped_mouse_pos.x, selected_card.global_position.y, mapped_mouse_pos.y)

func handle_dragging_with_ray_cast_impl() -> void:
	var hit: Vector3 = _mouse_hit_on_drag_plane()
	if hit == null:
		return
	selected_card.global_position = hit
	
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
#endregion

func play_card(lane: Lane)-> void:
	lane.add_card_to_lane(selected_card)
	state_chart.send_event("OnPlay")
