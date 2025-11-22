class_name ItemPedestal
extends Control

# preloaded item to instance off of 
const ITEM_PRELOAD := preload("res://scenes/item/item.tscn")

@export var item_data: ItemData

func _ready() -> void:
	assert(item_data, "Need to set item_data")
	var display_item: Item = _instance_item()
	add_child(display_item)

func _instance_item() -> Item:
	var display_item: Item = ITEM_PRELOAD.instantiate()
	display_item.item_data = item_data.duplicate()
	display_item.size = Vector2(32,32)
	# Calculating offset of the border
	display_item.position += Vector2(5,5)
	return display_item
