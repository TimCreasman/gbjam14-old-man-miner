class_name OMM_WorldGenerator
extends Node2D

@export_category("Internal Components")

signal generated()

@export var player_coordinate: OMM_Coordinate
@export var ref_rect: ReferenceRect

@export var tile_generator: OMM_TileGenerator
@export var structure_generator : OMM_StructureGenerator

const TILE_SIZE = 8
const GENERATION_OFFSET = 36 * TILE_SIZE

## In tiles
const HALF_SCREEN_HEIGHT = 9
const HALF_SCREEN_WIDTH = 10
const SCREEN_PADDING = 0

var max_depth: float

func _ready():
	player_coordinate.coordinate_changed.connect(on_coordinate_changed)
	on_coordinate_changed(player_coordinate.coordinate)

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

			if y <= max_depth && y >= (max_depth - 10 * TILE_SIZE):
				continue

			var pos = Vector2i(x, y)
			tile_generator.generate(pos)

			if y >= max_depth:
				continue

			structure_generator.generate(pos)
