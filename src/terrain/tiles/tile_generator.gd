class_name OMM_TileGenerator
extends Node2D

@export var player_coordinate: OMM_Coordinate

@export var tile_container: Node2D
@export var destroyed_tiles: OMM_DestroyedPositions

@export var terrain_noise: OMM_TerrainNoise
@export var ref_rect: ReferenceRect

@export var structure_generator : OMM_StructureGenerator

const ObjectPool = preload("res://src/resources/object_pool.gd")

@export var tile_object_pool: Resource = preload("res://src/terrain/tiles/tile_pool.tres")

const TILE_SIZE = 8
const GENERATION_OFFSET = 36 * TILE_SIZE

## In tiles
const HALF_SCREEN_HEIGHT = 9
const HALF_SCREEN_WIDTH = 10
const SCREEN_PADDING = 0

func _ready():
	tile_object_pool.set_object_pool_node(tile_container)
	tile_object_pool.pre_populate_pool()

	player_coordinate.coordinate_changed.connect(on_coordinate_changed)
	on_coordinate_changed(player_coordinate.coordinate)

## Expand bounds to fit the whole screen (plus a tile)
func expand_bounds_around(coordinate: Vector2i) -> Rect2i:
	return Rect2i(coordinate, Vector2i.ZERO).grow_individual(
		(HALF_SCREEN_WIDTH + SCREEN_PADDING) * TILE_SIZE, 
		(HALF_SCREEN_HEIGHT + SCREEN_PADDING) * TILE_SIZE, 
		(HALF_SCREEN_WIDTH + SCREEN_PADDING) * TILE_SIZE, 
		(HALF_SCREEN_HEIGHT + SCREEN_PADDING) * TILE_SIZE
)

func on_coordinate_changed(coordinate: Vector2i):
	# pass
	var bounds = expand_bounds_around(coordinate)
	ref_rect.position = bounds.position
	ref_rect.custom_minimum_size = bounds.size

	_generate(bounds)

func _generate(generation_bounds: Rect2i):
	for x in range(generation_bounds.position.x, generation_bounds.position.x + generation_bounds.size.x, TILE_SIZE):
		for y in range(generation_bounds.position.y, generation_bounds.position.y + generation_bounds.size.y, TILE_SIZE):
			if y < 0: continue
			_generate_tile(Vector2i(x, y))
			structure_generator.generate(Vector2i(x, y))
	# print_debug("Generated %s tiles" % count)
			# _generate_items(Vector2i(x, y))

func _generate_tile(global_pos: Vector2i):
	if destroyed_tiles.has_position(global_pos):
		return

	var tile_name = str(global_pos)
	if tile_container.has_node(tile_name):
		return

	var hardness = terrain_noise.get_ground_hardness(global_pos)

	if global_pos.y == 0: hardness = 1

	if hardness <= 0:
		return

	var tile = tile_object_pool.pull_from_pool({
		"global_position" : global_pos,
		"hardness" : hardness,
		"indestructable" : false,
		"name" : tile_name
	})
	
	if !tile.has_connections("pool_me"):
		tile.pool_me.connect(_on_object_pool_me)

func _on_object_pool_me(tile: OMM_GroundTile):
	tile_object_pool.add_to_pool(tile)
