class_name SlotGrid
extends Node

signal slot_grid_changed

var current_hovered_slot: ItemSlot : get = _get_hovered_slot

var slots: Dictionary

func _ready() -> void:
	for child: Node in get_tree().get_nodes_in_group("inventory_slots"):
		if child is ItemSlot:
			slots[child] = false
			setup_item_slot(child)

func setup_item_slot(slot: ItemSlot) -> void:
	slot.slot_hovered.connect(_on_slot_hovered)

func _on_slot_hovered(which: ItemSlot, is_hovering: bool) -> void:
	print(which, is_hovering)
	slots[which] = is_hovering
	
# Wraps slot.add_item_to_slot
func add_item(item: Item, slot: ItemSlot = current_hovered_slot) -> Item:
	# can have an item in the slot that needs to be swapped
	var swapped_item: Item = slot.add_item_to_slot(item)
	slot_grid_changed.emit()
	return swapped_item

func remove_item(slot: ItemSlot) -> void:
	if slot == null:
		return
	slot.remove_item()
	slot_grid_changed.emit()

func _get_hovered_slot() -> ItemSlot:
	var result = slots.keys().filter(func(k): return slots[k])
	print(len(result))
	return result[0]
