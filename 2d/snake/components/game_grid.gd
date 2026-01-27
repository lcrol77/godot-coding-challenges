class_name GameGrid
extends Node

@export var size: Vector2i
var grid: Dictionary

func _ready() -> void:
	for i in size.x:
		for j in size.y:
			grid[Vector2i(i,j)] = null

func add(tile: Vector2i, el: Node) -> void:
	grid[tile] = el

func remove(tile: Vector2i) -> void:
	grid[tile] = null

func is_tile_occupied(tile: Vector2i) -> bool:
	return grid[tile] != null

func is_grid_full() -> bool:
	return grid.keys().all(is_tile_occupied)

func get_all_empty_tiles() -> Array[Vector2i]:
	var empty_tiles: Array[Vector2i] = []
	for tile in grid:
		if not is_tile_occupied(tile):
			empty_tiles.append(tile)
	# No empty tiles
	return empty_tiles

func get_random_empty_tile() -> Vector2i:
	return get_all_empty_tiles().pick_random()
