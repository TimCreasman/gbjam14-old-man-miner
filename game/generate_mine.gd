@tool
extends Node2D

@export var chunk_size: Vector2i = Vector2i.ZERO:
	set(value):
		chunk_size = value
		if noise_map:
			noise_map.width = chunk_size.x
			noise_map.height = chunk_size.y 
			_generate()
@export var chunk_index: int:
	set(value):
		chunk_index = value
		if noise_map:
			noise_map.noise.offset.y = chunk_size.y * value
			_generate()
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var tile_size: Vector2i = Vector2i(8,8)
@export var tile: PackedScene

@export var depth_component: OMM_DepthComponent

@export_category("Internal Components")
@export var tile_container: CanvasGroup
@export var noise_map: NoiseTexture2D

const CHUNK_SCENE: PackedScene = preload("res://game/scene/chunk.tscn")

@export_tool_button("Generate level") var generate_button = _generate

func _ready():
	if depth_component:
		depth_component.changed.connect(_generate_chunk_at_depth)

func _generate_chunk_at_depth():
	if _depth_to_chunk_index() == chunk_index:
		return

	chunk_index = _depth_to_chunk_index()
	# _generate_chunk(chunk_size, _depth_to_chunk_index())

func _depth_to_chunk_index() -> int:
	return depth_component.get_depth() / (chunk_size.y * tile_size.y)

func _generate():
	_generate_chunk(chunk_size, chunk_index)

func _generate_chunk(_size: Vector2i, _chunk_index: int):
	# if tile_container.find_child(str(_chunk_index)):
	# 	return

	var grid = _get_grid_at_chunk_depth(_size, _chunk_index * _size.y)
	print("INIT CHUNK")
	_init_chunk(_size, grid)

func _get_grid_at_chunk_depth(_size: Vector2i, depth_offset: int) -> Dictionary:
	var grid = {}

	for x in range(_size.x):
		for y in range(_size.y):
			y += depth_offset

			var value_at_pos = noise_map.noise.get_noise_2d(x, y)
			grid[[x, y]] = {
				'hardness' : floori(remap(value_at_pos, 0, 1, 0, 10))
			}

	return grid

func _init_chunk(_chunk_size: Vector2i, grid: Dictionary):
	var _first_coord = grid.keys()[0]
	var _chunk_index = (_first_coord[1] / _chunk_size.y)
	var _chunk_container = CHUNK_SCENE.instantiate() as OMM_Chunk

	_chunk_container.name = str(_chunk_index)

	# TODO clean up coord math
	_chunk_container.screen_notifier.rect = Rect2i(Vector2i(_first_coord[0] * tile_size.x, _first_coord[1] * tile_size.y), _chunk_size * tile_size)

	tile_container.add_child(_chunk_container)
	_chunk_container.owner = get_tree().edited_scene_root

	_init_tiles(_chunk_container, grid)

func _init_tiles(chunk_container: Node2D, grid: Dictionary):
	for coord in grid.keys():

		var tile_scene = tile.instantiate()
		if tile_scene is OMM_GroundTile:
			tile_scene.hardness = grid[coord]['hardness']
			tile_scene.global_position = Vector2i(coord[0] * tile_size.x, coord[1] * tile_size.y)

			chunk_container.add_child(tile_scene)
			tile_scene.owner = get_tree().edited_scene_root
