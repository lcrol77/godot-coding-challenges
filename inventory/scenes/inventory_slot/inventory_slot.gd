class_name ItemSlot
extends CenterContainer

signal slot_hovered(which: ItemSlot, is_hovering: bool)

@export var item_scene: PackedScene = preload("res://scenes/item/item.tscn")
@export var item: Item


# returns an item if we are swapping an item, else returns null
func add_item_to_slot(new_item: Item) -> Item:
	# TODO: handle swaps and other ops
	if not self.is_empty():
		return null

	self.item = new_item
	self.item.z_index = 64

	if new_item.get_parent():
		new_item.reparent(self)  # move an existing item
	else:
		self.add_child(new_item)  # brand-new item

	return null

func remove_item() -> void:
	item = null

func is_empty() -> bool:
	return item == null

func _on_texture_button_mouse_entered() -> void:
	slot_hovered.emit(self, true)

func _on_texture_button_mouse_exited() -> void:
	slot_hovered.emit(self, false)
