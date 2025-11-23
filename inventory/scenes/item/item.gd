@tool
class_name Item
extends TextureRect

@export var item_data: ItemData: set = set_item_data
@onready var dnd: DragAndDrop = $Dnd

func _ready() -> void:
	if not Engine.is_editor_hint():
		dnd.drag_canceled.connect(_on_drag_canceled)

func _on_drag_canceled(starting_position: Vector2):
	reset_after_dragging(starting_position)

func reset_after_dragging(starting_position: Vector2):
	global_position = starting_position

func set_item_data(val: ItemData) -> void:
	item_data = val
	if val == null:
		return
	if not is_node_ready():
		await ready
	self.texture = item_data.image
