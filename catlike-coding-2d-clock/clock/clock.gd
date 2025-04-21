class_name Clock
extends Node2D

enum StartTimeMode{ SYSTEM_TIME, RANDOM_TIME, FIXED_TIME, OFFSET_TIME}

@export var time_scale := 1.0
@export var start_time: StartTimeMode = StartTimeMode.SYSTEM_TIME
@export_group("Fixed or Offset Start Time")
@export_range(0,11) var start_hour := 0
@export_range(0,59) var start_min := 0
@export_range(0,59) var start_sec := 0

@onready var hour_arm: Polygon2D = $HourArm
@onready var minute_arm: Polygon2D = $MinuteArm
@onready var second_arm: Polygon2D = $SecondArm

var seconds: float

func _ready() -> void:
	if start_time == StartTimeMode.RANDOM_TIME:
		seconds = randf_range(0.0,43200.0)
	else:
		if start_time != StartTimeMode.FIXED_TIME:
			var current_time = Time.get_time_dict_from_system()
			seconds = float(
					current_time.second +
					current_time.minute * 60 + 
					current_time.hour * 3600
			)
		if start_time != StartTimeMode.SYSTEM_TIME:
			seconds += start_sec + start_min * 60 + start_hour * 3600

func _process(delta: float) -> void:
	seconds += delta * time_scale
	set_time()

func set_time():
	second_arm.rotation = fmod(seconds, 60.0) * TAU / 60
	minute_arm.rotation = fmod(seconds / 60.0, 60.0) * TAU / 60
	hour_arm.rotation = fmod(seconds/3600, 12.0) * TAU / 12
