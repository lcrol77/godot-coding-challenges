class_name ItemMover
extends Node

@export var slot_grid: SlotGrid
var origin_slot: ItemSlot

func _ready() -> void:
	var items := get_tree().get_nodes_in_group("items")
	for item: Item in items:
		setup_item(item)

# Do stuff here like setup dnd signal connections
func setup_item(item: Item) -> void:
	item.dnd.drag_started.connect(_on_item_drag_started.bind(item))
	item.dnd.drag_canceled.connect(_on_item_drag_canceled.bind(item))
	item.dnd.dropped.connect(_on_item_dropped.bind(item))

func _reset_item_to_starting_pos(starting_pos: Vector2, item: Item) -> void:
	item.reset_after_dragging(starting_pos)
	slot_grid.add_item(item, origin_slot)
	origin_slot = null
	
func _move_item(item: Item) -> void: 
	var slot: ItemSlot = slot_grid.current_hovered_slot
	slot_grid.add_item(item, slot)
	item.global_position = slot.global_position

#region
func _on_item_drag_started(item: Item) -> void:
	origin_slot = item.get_parent() as ItemSlot
	if origin_slot != null:
		slot_grid.remove_item(origin_slot)
	
func _on_item_drag_canceled(starting_pos: Vector2, item: Item) -> void:
	_reset_item_to_starting_pos(starting_pos,item)
	
func _on_item_dropped(starting_pos: Vector2, item: Item) -> void:
	if slot_grid.current_hovered_slot == null:
		_reset_item_to_starting_pos(starting_pos,item)
		return
	_move_item(item)
#endregion
