class_name Wall
extends CSGBox3D

var cam_visible = true
var visibile_speed = 0.1
var hide_speed = 0.3

func _process(delta: float) -> void:	
	if cam_visible:
		material.albedo_color = lerp(material.albedo_color, Color("#7a0e0e"), visibile_speed)
	else:
		material.albedo_color = lerp(material.albedo_color, Color("#007a0e0e"), hide_speed)
	cam_visible = true
