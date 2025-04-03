class_name Star
extends Node2D

var x: float
var y: float
var z: float
var view_port_size: Vector2
var view_port_half_size: int

func _ready() -> void:
	view_port_size = get_viewport().get_visible_rect().size
	view_port_half_size = view_port_size.x / 2
	x = randi_range(-view_port_size.x + view_port_half_size, view_port_size.x - view_port_half_size)
	y = randi_range(-view_port_size.x + view_port_half_size, view_port_size.x - view_port_half_size)
	z = randi_range(0, view_port_size.x)

func _draw() -> void:
	var sx: float = remap(x/z,0,1,0,view_port_size.x)
	var sy: float = remap(y/z,0,1,0,view_port_size.x) 
	var r: float = remap(z, 0, view_port_size.x, 10, 0)
	draw_circle(Vector2(sx,sy), r,  Color(1,1,1))

func _physics_process(delta: float) -> void:
	z = z - 10
	if z < 1:
		x = randi_range(-view_port_size.x + view_port_half_size, view_port_size.x - view_port_half_size)
		y = randi_range(-view_port_size.x + view_port_half_size, view_port_size.x - view_port_half_size)
		z = randi_range(0, view_port_size.x)
	
func _process(delta: float) -> void:
	queue_redraw()
