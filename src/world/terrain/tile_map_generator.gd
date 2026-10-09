class_name OMM_TileMapGenerator
extends TileMapLayer

@export var terrain_noise: OMM_TerrainNoise
@export var half_depth_terrain_noise: OMM_TerrainNoise

@export var break_sound: AudioStreamPlayer2D
@export var destroy_sound: AudioStreamPlayer2D

# Kept as its own instance to support GPU particles
@export var gold_tile_scene: PackedScene

var max_depth: float


func _ready():
	load_cfg()


func load_cfg():
	var world_gen_cfg = ConfigFile.new()
	var err = world_gen_cfg.load("res://src/world/world_gen.cfg")
	if err != OK:
		print_debug("Could not load world gen config file")

	max_depth = world_gen_cfg.get_value("main", "max_depth", INF)


func generate(tile_global_position: Vector2i) -> bool:
	var tile_map_coords = _global_to_map_coords(tile_global_position)

	var hardness = terrain_noise.get_ground_hardness(tile_global_position)

	if tile_global_position.y >= max_depth + 80 && tile_global_position.y <= max_depth - 80:
		return false

	if tile_global_position.y >= max_depth:
		hardness = 9
	elif tile_global_position.y >= max_depth / 2:
		hardness = half_depth_terrain_noise.get_ground_hardness(tile_global_position)

	if hardness == 0:
		return false

	set_cell(tile_map_coords, 0, Vector2i(hardness, 0), 0)
	_set_tile_custom_data(tile_global_position, hardness)
	return true


func is_ground_below(tile_global_position: Vector2i):
	var empty = Vector2i(-1, -1)
	var map_coords = _global_to_map_coords(tile_global_position)
	var cell_below_coords = get_neighbor_cell(map_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	var cell_atlas = get_cell_atlas_coords(map_coords)
	var cell_below_atlas = get_cell_atlas_coords(cell_below_coords)
	return cell_atlas == empty && cell_below_atlas != empty


func break_tile(tile_global_position: Vector2i):
	# generated_positions.add_position(tile_global_position)
	var map_coords = _global_to_map_coords(tile_global_position)
	var atlas_coords = get_cell_atlas_coords(map_coords)
	if atlas_coords.x == 1:
		_remove_tile(tile_global_position)
		return
	set_cell(map_coords, 0, Vector2i(atlas_coords.x - 1, 0), 0)
	break_sound.global_position = tile_global_position
	break_sound.play()


func remove_radius(start_global_position: Vector2i, radius: int):
	over_radius(start_global_position, radius, _remove_tile)


func over_radius(start_global_position: Vector2i, radius: int, do_method: Callable):
	for x in range(start_global_position.x - radius, start_global_position.x + radius, 8):
		for y in range(start_global_position.y - radius, start_global_position.y + radius, 8):
			var global_coords = Vector2i(x, y).snappedi(8)
			if global_coords.distance_to(start_global_position) > radius:
				continue
			do_method.call(global_coords)


func add_gold_tile(global_coords: Vector2i):
	var map_coords = to_local(local_to_map(global_coords))
	if get_tree().get_nodes_in_group(OMM_VectorUtils.hash_vector(map_coords)):
		return
	if get_cell_source_id(map_coords) < 0:
		return

	var gold_tile = gold_tile_scene.instantiate() as Node2D
	gold_tile.position = to_global(map_to_local(map_coords))
	gold_tile.add_to_group(OMM_VectorUtils.hash_vector(map_coords))
	add_child(gold_tile)


func _global_to_map_coords(global_pos: Vector2i):
	return local_to_map(to_local(global_pos))


func _remove_tile(global_coords: Vector2i):
	var map_coords = _global_to_map_coords(global_coords)
	var nodes_at_position = get_tree().get_nodes_in_group(OMM_VectorUtils.hash_vector(map_coords))
	for node in nodes_at_position:
		if node.has_method("do_destroy"):
			node.call("do_destroy")

	erase_cell(map_coords)
	destroy_sound.global_position = global_coords
	destroy_sound.play()


func _set_tile_custom_data(map_coords: Vector2i, hardness: int):
	if hardness >= 9:
		add_gold_tile(map_coords)
