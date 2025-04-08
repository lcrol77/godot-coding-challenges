extends Node2D

@export var PIXEL_SIZE: int = 20
@export var game_grid: GameGrid
@export var stats: Stats
@export var game_over_scene: PackedScene = preload("res://game_over.tscn")

@onready var ui_canvas_layer: CanvasLayer = $UICanvasLayer
@onready var snake: Area2D = $Snake


const APPLE = preload("res://components/apple.tscn")
func _ready() -> void:
	Events.game_over.connect(handle_game_over)
	Events.grid_add.connect(handle_grid_add)
	Events.grid_remove.connect(handle_grid_remove)
	Events.apple_eaten.connect(handle_apple_eaten)
	_instance_new_apple()
	
func handle_game_over():
	snake.set_process(false)
	snake.set_physics_process(false)
	show_game_over()

func show_game_over() -> void:
	var instance = game_over_scene.instantiate()
	ui_canvas_layer.add_child(instance)
	instance.retry.connect(on_game_over_retry)

func on_game_over_retry() -> void:
	var main_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(main_scene_path)

func handle_grid_add(node: Node2D):
	game_grid.add(get_tile_from_global(node.position), node)

func handle_grid_remove(pos: Vector2):
	game_grid.remove(get_tile_from_global(pos))
	
func _instance_new_apple():
	var pos : Vector2 = get_global_from_tile(game_grid.get_random_empty_tile())
	var inst : Area2D = APPLE.instantiate()
	inst.global_position = pos
	call_deferred("add_child", inst)
	
func handle_apple_eaten() -> void:
	_instance_new_apple()
	print(stats.score)
	stats.score = stats.score + 1

func get_tile_from_global(global_pos: Vector2) -> Vector2i:
	var tile_x := int(global_pos.x) / PIXEL_SIZE
	var tile_y := int(global_pos.y) / PIXEL_SIZE
	return Vector2i(tile_x, tile_y)
	
func get_global_from_tile(tile: Vector2i) -> Vector2:
	return Vector2(tile.x * PIXEL_SIZE + 10, tile.y * PIXEL_SIZE + 10)


func _on_quit_btn_pressed() -> void:
	print("pressed")
