class_name Clock
extends Node2D

@onready var hour_arm: Polygon2D = $HourArm
@onready var minute_arm: Polygon2D = $MinuteArm
@onready var second_arm: Polygon2D = $SecondArm

func _ready() -> void:
	set_time()

func _process(delta: float) -> void:
	set_time()

func set_time():
	var current_time = Time.get_time_dict_from_system()
	second_arm.rotation = current_time.second * TAU / 60
	minute_arm.rotation = current_time.minute * TAU / 60
	hour_arm.rotation = current_time.hour * TAU / 12
