class_name SlotGrid
extends Container

@export var dimesions: Vector2i


signal slot_grid_changed
var slots: Dictionary
var bounds: Rect2i


func _ready() -> void:
	bounds = Rect2i(Vector2.ZERO, dimesions)

func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))

func get_global_from_tile(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))

func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())

func is_tile_in_bounds(tile: Vector2i) -> bool:
	return bounds.has_point(tile)

# Wraps slot.add_item_to_slot
func add_item(item: Item, slot: ItemSlot) -> Item:
	# can have an item in the slot that needs to be swapped
	var swapped_item: Item = slot.add_item_to_slot(item)
	slot_grid_changed.emit()
	return swapped_item

func remove_item(slot: ItemSlot) -> void:
	if slot == null:
		return
	slot.remove_item()
	slot_grid_changed.emit()
