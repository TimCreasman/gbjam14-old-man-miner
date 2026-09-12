@tool
extends Node2D

@export var size: Vector2i = Vector2i.ZERO
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var tile_size: Vector2i = Vector2i(8,8)
@export var tile: PackedScene

@export_tool_button("Generate level") var generate = func ():
	for child in get_children():
		remove_child(child)
	# clear()
	var grid = random_grid(size)
	generate_tiles(grid)

static var rng = RandomNumberGenerator.new()

func random_grid(_size: Vector2i) -> Dictionary:
	var grid = {}

	for x in range(_size.x):
		for y in range(_size.y):
			# set_cell(Vector2i(x, y), 1, Vector2i.ZERO, 1)
			# tile_set.get_source(
			grid[[x, y]] = {
				# 'scene' : 
				'hardness' : rng.randi_range(0, 10)
			}

	return grid

func generate_tiles(grid: Dictionary):
	for coord in grid.keys():
		var tile_scene = tile.instantiate()
		if tile_scene is OMM_GroundTile:
			tile_scene.hardness = grid[coord]['hardness']
			tile_scene.global_position = Vector2i(coord[0] * tile_size.x, coord[1] * tile_size.y)
			add_child(tile_scene)
			tile_scene.owner = get_tree().edited_scene_root
		# print()
