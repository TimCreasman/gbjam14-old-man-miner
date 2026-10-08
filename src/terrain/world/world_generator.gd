class_name OMM_WorldGenerator
extends Node2D

@export_category("Internal Components")

@export var player_coordinate: OMM_Coordinate
@export var ref_rect: ReferenceRect

# @export var tile_generator: OMM_TileGenerator
@export var tile_map_generator: OMM_TileMapGenerator
@export var structure_generator : OMM_StructureGenerator
@export var item_generator : OMM_ItemGenerator

@export var generated_positions: OMM_Positions

var name_resource = preload("res://src/resources/string_resources/name_resource.tres")
var terrain_noise = preload("res://src/terrain/world/noise/cave_generation_noise.tres")

const TILE_SIZE = 8
const GENERATION_OFFSET = 36 * TILE_SIZE

## In tiles
const HALF_SCREEN_HEIGHT = 9
const HALF_SCREEN_WIDTH = 10
const SCREEN_PADDING = 2

var max_depth: float

func _init():
	terrain_noise.set_name_seed(name_resource.get_value())

func _ready():
	player_coordinate.coordinate_changed.connect(on_coordinate_changed)
	# player_coordinate.coordinate_changed_delta.connect(on_coordinate_changed_delta)
	on_coordinate_changed(player_coordinate.coordinate)
	TileMapManager.set_tilemap(tile_map_generator)

	# Load bounds of the screen once.
	# _generate(expand_bounds_around(player_coordinate.coordinate))

	load_cfg()

func load_cfg():
	var world_gen_cfg = ConfigFile.new()
	var err = world_gen_cfg.load("res://src/terrain/world/world_gen.cfg")
	if err!= OK:
		print_debug("Could not load world gen config file")

	max_depth = world_gen_cfg.get_value("main", "max_depth", INF)

## Expand bounds to fit the whole screen (plus a tile)
func expand_bounds_around(coordinate: Vector2i) -> Rect2i:
	return Rect2i(coordinate, Vector2i.ZERO).grow_individual(
		(HALF_SCREEN_WIDTH + SCREEN_PADDING) * TILE_SIZE, 
		(HALF_SCREEN_HEIGHT + SCREEN_PADDING) * TILE_SIZE, 
		(HALF_SCREEN_WIDTH + SCREEN_PADDING) * TILE_SIZE, 
		(HALF_SCREEN_HEIGHT + SCREEN_PADDING) * TILE_SIZE
)

func on_coordinate_changed_delta(coordinate, delta):
	var height = 0;
	var width = 0
	var y = 0
	var x = 0

	if abs(delta.y) > 0:
		height = 32
		width = 176
		x = -HALF_SCREEN_WIDTH * 8
		y = 10 * delta.y - (height / 2.0)

	if abs(delta.x) > 0:
		width = 32
		height = 160
		y = -HALF_SCREEN_HEIGHT * 8
		x = 10 * delta.x - (width / 2.0)

	ref_rect.position = coordinate + (Vector2i(x, y))
	ref_rect.size = Vector2i(width, height)

	_generate(ref_rect.get_rect())

func on_coordinate_changed(coordinate: Vector2i):
	# pass
	var bounds = expand_bounds_around(coordinate)
	ref_rect.position = bounds.position
	ref_rect.size = bounds.size

	_generate(bounds)

func _generate(generation_bounds: Rect2i):
	for x in range(generation_bounds.position.x, generation_bounds.position.x + generation_bounds.size.x, TILE_SIZE):
		for y in range(generation_bounds.position.y, generation_bounds.position.y + generation_bounds.size.y, TILE_SIZE):
			if y < 144: continue
			var pos = Vector2i(x, y)
			if generated_positions.has_position(pos): continue

			var generated = tile_map_generator.generate(pos)
			if generated:
				generated_positions.add_position(pos)

			# Skip generating this position if a tile took its place
			if generated: continue

			generated = structure_generator.generate(pos, tile_map_generator)
			if generated:
				generated_positions.add_position(pos)

			generated = item_generator.generate(pos)
			if generated:
				generated_positions.add_position(pos)

			# if y <= max_depth && y >= (max_depth - 10 * TILE_SIZE):
			# 	continue
			#
			# if y >= max_depth:
			# 	continue
