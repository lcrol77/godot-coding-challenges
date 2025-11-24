class_name ItemSlot
extends CenterContainer

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
		new_item.reparent(self)  # move an existisng item
	else:
		self.add_child(new_item)  # brand-new item

	return null

func remove_item() -> void:
	item = null

func is_empty() -> bool:
	return item == null
