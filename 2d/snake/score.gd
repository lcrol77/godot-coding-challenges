class_name Stats
extends Panel

@onready var label: Label = $Label
var score: int:
	set(val):
		score = val
		if label != null:
			label.text = str(val)
