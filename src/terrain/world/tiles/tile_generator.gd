class_name OMM_TileGenerator
extends Node2D

@export var player_coordinate: OMM_Coordinate

@export var tile_container: Node2D
@export var destroyed_tiles: OMM_DestroyedPositions

@export var terrain_noise: OMM_TerrainNoise
@export var half_depth_terrain_noise: OMM_TerrainNoise
@export var ref_rect: ReferenceRect

@export var structure_generator : OMM_StructureGenerator

var tile_object_pool: OMM_ObjectPool 
var max_depth: float

func _ready():
	tile_object_pool = OMM_ObjectPool.new(26 * 24, "res://src/terrain/world/tiles/tile.tscn", 
{
	"name": "inactive",
	"global_position": Vector2(0, -8),
	"hardness": 0,
	"indestructable": true,
	"visible": false,
	"process_mode": Node.PROCESS_MODE_DISABLED
}, tile_container)

	load_cfg()

func load_cfg():
	var world_gen_cfg = ConfigFile.new()
	var err = world_gen_cfg.load("res://src/terrain/world/world_gen.cfg")
	if err!= OK:
		print_debug("Could not load world gen config file")

	max_depth = world_gen_cfg.get_value("main", "max_depth", INF)

func generate(global_pos: Vector2i):
	if destroyed_tiles.has_position(global_pos):
		return

	var tile_name = str(global_pos)
	if tile_container.has_node(tile_name):
		return

	var hardness = 0
	if global_pos.y >= max_depth:
		hardness = 9
	elif global_pos.y >= max_depth / 2:
		hardness = half_depth_terrain_noise.get_ground_hardness(global_pos)
	else:
		hardness = terrain_noise.get_ground_hardness(global_pos)

	# No gold before 80 below
	if hardness == 9 && global_pos.y < 160:
		hardness -= 1

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
