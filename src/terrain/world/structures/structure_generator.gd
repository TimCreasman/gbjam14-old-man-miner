class_name OMM_StructureGenerator
extends Node2D

@export var structures: Array[OMM_StructureDefinition] = []
@export var terrain_noise: OMM_TerrainNoise
@export var half_depth_terrain_noise: OMM_TerrainNoise

var _spawn_container: Node2D = self

@export var generated_positions: OMM_Positions

var max_depth

func _ready():
	load_cfg()

func load_cfg():
	var world_gen_cfg = ConfigFile.new()
	var err = world_gen_cfg.load("res://src/terrain/world/world_gen.cfg")
	if err!= OK:
		print_debug("Could not load world gen config file")

	max_depth = world_gen_cfg.get_value("main", "max_depth", INF)

func set_spawn_container(container: Node2D):
	_spawn_container = container

func sparse_noise_at(global_pos: Vector2, _seed: int):
	return OMM_RandomNoise.get_noise_2dv(global_pos, 1, _seed)

func is_space(rect: Rect2i) -> bool:
	for x in range(rect.position.x, rect.position.x + rect.size.x, 8):
		if !terrain_noise.is_ground(Vector2i(x, rect.position.y + 8)):
			return false

		for y in range(rect.position.y, rect.position.y - rect.size.y, -8):
			if terrain_noise.is_ground(Vector2i(x, y)):
				return false
	return true

func add_space(rect: Rect2i):
	for x in range(rect.position.x, rect.position.x + rect.size.x, 8):
		for y in range(rect.position.y, rect.position.y - rect.size.y, -8):
			generated_positions.add_position(Vector2(x, y))

## Returns true if something was generated
func generate(global_pos: Vector2i, tile_map_layer: OMM_TileMapGenerator) -> bool:
	if !tile_map_layer: return false
	if global_pos.y >= max_depth: return false
	if !tile_map_layer.is_ground_below(global_pos): return false
	
	for i in structures.size():
		var structure_to_spawn = structures[i]

		if !sparse_noise_at(global_pos, 1000 * i): continue

		var structure_rect = Rect2i(global_pos, structure_to_spawn.size * 8)

		if !is_space(structure_rect): continue

		var structure_name = "str" + str(global_pos).sha1_text()
		if !_spawn_container.has_node(structure_name):
			var structure_scene = structure_to_spawn.scene.instantiate()
			structure_scene.position = global_pos
			structure_scene.name = structure_name
			_spawn_container.add_child(structure_scene)

			# mark all positions within structure rect as generated
			add_space(structure_rect)


	return true
