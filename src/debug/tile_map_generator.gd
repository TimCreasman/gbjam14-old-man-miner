class_name OMM_TileMapGenerator
extends TileMapLayer

@export var terrain_noise: OMM_TerrainNoise
@export var generated_tiles: OMM_DestroyedPositions

# Kept as its own instance to support GPU particles
# TODO revist this appraoch
@export var gold_tile_scene: PackedScene

# class TileCustomData:
# 	var 

func global_to_map_coords(global_pos: Vector2i):
	return local_to_map(to_local(global_pos))

func generate(tile_global_position: Vector2i):
	var tile_map_coords = global_to_map_coords(tile_global_position)

	if generated_tiles.has_position(tile_map_coords):
		return
	generated_tiles.add_position(tile_map_coords)

	# if global_pos.y >= max_depth:
	# 	hardness = 9
	# elif global_pos.y >= max_depth / 2:
	# 	hardness = half_depth_terrain_noise.get_ground_hardness(global_pos)
	# else:
	var hardness = terrain_noise.get_ground_hardness(tile_global_position)
	if hardness == 0:
		return

	set_cell(tile_map_coords, 0, Vector2i(hardness,0), 0)
	_set_tile_custom_data(tile_map_coords, hardness)

func break_tile(tile_global_position: Vector2i):
	# generated_tiles.add_position(tile_global_position)
	var map_coords = global_to_map_coords(tile_global_position)
	var atlas_coords = get_cell_atlas_coords(map_coords)
	if atlas_coords.x == 1:
		_remove_tile(map_coords)
		return
	set_cell(map_coords, 0, Vector2i(atlas_coords.x - 1, 0), 0)

func remove_radius(start_global_position: Vector2i, radius: int):
	for x in range(start_global_position.x - radius, start_global_position.x + radius, 8):
		for y in range(start_global_position.y - radius, start_global_position.y + radius, 8):
			var global_coords = Vector2i(x, y).snappedi(8)
			if global_coords.distance_to(start_global_position) > radius:
				continue

			var map_coords = global_to_map_coords(global_coords)
			_remove_tile(map_coords)

func _remove_tile(map_coords: Vector2i):
	var nodes_at_position = get_tree().get_nodes_in_group(OMM_VectorUtils.hash_vector(map_coords))
	for node in nodes_at_position:
		node.queue_free()
	erase_cell(map_coords)

func _set_tile_custom_data(map_coords: Vector2i, hardness: int):
	if hardness >= 9:
		var gold_tile = gold_tile_scene.instantiate() as Node2D
		gold_tile.position = to_global(map_to_local(map_coords))
		gold_tile.add_to_group(OMM_VectorUtils.hash_vector(map_coords))
		add_child(gold_tile)
