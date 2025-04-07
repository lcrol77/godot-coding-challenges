extends Node2D

@export var PIXEL_SIZE: int = 20
@export var game_grid: GameGrid
const APPLE = preload("res://components/apple.tscn")
func _ready() -> void:
	Events.game_over.connect(handle_game_over)
	Events.grid_add.connect(handle_grid_add)
	Events.grid_remove.connect(handle_grid_remove)
	Events.apple_eaten.connect(handle_apple_eaten)
	handle_apple_eaten()
	
func handle_game_over():
	print("Game Over")
	get_tree().paused = true

func handle_grid_add(node: Node2D):
	game_grid.add(get_tile_from_global(node.position), node)

func handle_grid_remove(pos: Vector2):
	game_grid.remove(get_tile_from_global(pos))

func handle_apple_eaten() -> void:
	var pos : Vector2 = get_global_from_tile(game_grid.get_random_empty_tile())
	var inst : Area2D = APPLE.instantiate()
	inst.global_position = pos
	call_deferred("add_child", inst)
	
func get_tile_from_global(global_pos: Vector2) -> Vector2i:
	var tile_x := int(global_pos.x) / PIXEL_SIZE
	var tile_y := int(global_pos.y) / PIXEL_SIZE
	return Vector2i(tile_x, tile_y)
	
func get_global_from_tile(tile: Vector2i) -> Vector2:
	return Vector2(tile.x * PIXEL_SIZE + 10, tile.y * PIXEL_SIZE + 10)
