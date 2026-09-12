@tool
extends Node2D

@export var size: Vector2i = Vector2i.ZERO:
	set(value):
		size = value
		if noise_map:
			noise_map.width = size.x
			noise_map.height = size.y 

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var tile_size: Vector2i = Vector2i(8,8)
			
@export var tile: PackedScene

@export_category("Internal Components")
@export var tile_container: CanvasGroup
@export var noise_map: NoiseTexture2D

@export_tool_button("Generate level") var generate = func ():
	for child in tile_container.get_children():
		tile_container.remove_child(child)
	# clear()
	var grid = random_grid(size)
	generate_tiles(grid)

static var rng = RandomNumberGenerator.new()

func random_grid(_size: Vector2i) -> Dictionary:
	var grid = {}

	for x in range(_size.x):
		for y in range(_size.y):
			var color = noise_map.get_image().get_pixel(x, y)
			grid[[x, y]] = {
				# Noise maps are greyscale so we only need one channel
				'hardness' : floori(remap(color.r, 0, 1, 0, 10))
			}

	return grid

func generate_tiles(grid: Dictionary):
	for coord in grid.keys():
		# print(grid[coord]['hardness'])
		# if grid[coord]['hardness'] == 0:
		# 	continue

		var tile_scene = tile.instantiate()
		if tile_scene is OMM_GroundTile:
			tile_scene.hardness = grid[coord]['hardness']
			tile_scene.global_position = Vector2i(coord[0] * tile_size.x, coord[1] * tile_size.y)

			tile_container.add_child(tile_scene)
			tile_scene.owner = get_tree().edited_scene_root
