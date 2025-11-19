@tool
class_name Item
extends TextureRect

@export var item_data: ItemData: set = set_item_data
@onready var dnd: DragAndDrop = $Dnd

var is_hovered: bool

func _ready() -> void:
	if not Engine.is_editor_hint():
		dnd.drag_started.connect(_on_drag_started)
		dnd.drag_canceled.connect(_on_drag_canceled)

func _on_drag_started():
	pass

func _on_drag_canceled():
	pass

func set_item_data(val: ItemData) -> void:
	item_data = val
	if val == null:
		return
	if not is_node_ready():
		await ready
	self.texture = item_data.image

func _on_mouse_entered() -> void:
	if dnd.dragging:
		return
	is_hovered = true

func _on_mouse_exited() -> void:
	if dnd.dragging:
		return
	is_hovered = false
