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

@export var depth_component: OMM_DepthComponent
@export var score_component: OMM_ScoreComponent

@export_category("Internal Components")
@export var tile_container: CanvasGroup
@export var noise_map: NoiseTexture2D

const CHUNK_SCENE: PackedScene = preload("res://src/terrain/chunk.tscn")

class OMM_TileData:
	var hardness := 0
	var indestructable := false
	func _init(_hardness: int, _indestructable: bool):
		self.hardness = _hardness
		self.indestructable = _indestructable

# Turn back on if a tool script
@export_tool_button("Generate level") var generate_button = _generate

func _ready():
	if depth_component:
		depth_component.changed.connect(_generate_chunk_at_depth)

func _generate_chunk_at_depth(depth: int):
	var _new_chunk_index = _depth_to_chunk_index(depth)
	if _new_chunk_index == chunk_index:
		return

	# TODO this is spaghetti
	chunk_index = _new_chunk_index
	# _generate_chunk(chunk_size, _depth_to_chunk_index())

func _depth_to_chunk_index(depth: int) -> int:
	return depth / (chunk_size.y * tile_size.y)

func _generate():
	_generate_chunk(chunk_size, chunk_index)

func _generate_chunk(_size: Vector2i, _chunk_index: int):
	var grid = _get_grid_at_chunk_depth(_size, _chunk_index * _size.y)
	_init_chunk(_size, grid)

func _get_grid_at_chunk_depth(_size: Vector2i, depth_offset: int) -> Dictionary[Array, OMM_TileData]:
	var grid: Dictionary[Array, OMM_TileData] = {}

	for x in range(_size.x):
		for y in range(_size.y):
			y += depth_offset

			var data : OMM_TileData
			if x == 0 || x == _size.x - 1:
				data = OMM_TileData.new(8, true)
			else:
				var noise_at_pos = noise_map.noise.get_noise_2d(x, y)
				data = OMM_TileData.new(floori(remap(noise_at_pos, 0, 1, 0, 10)), false)

			grid[[x, y]] = data
			
	return grid

func _init_chunk(_chunk_size: Vector2i, grid: Dictionary[Array, OMM_TileData]):
	var _first_coord = grid.keys()[0]
	var _chunk_index = (_first_coord[1] / _chunk_size.y)
	var _chunk_container = CHUNK_SCENE.instantiate() as OMM_Chunk

	_chunk_container.name = str(_chunk_index)

	# TODO clean up coord math
	_chunk_container.screen_notifier.rect = Rect2i(tile_pos_to_screen_space(Vector2i(_first_coord[0], _first_coord[1])), _chunk_size * tile_size)

	tile_container.add_child(_chunk_container)
	if Engine.is_editor_hint():
		_chunk_container.owner = get_tree().edited_scene_root

	_init_tiles(_chunk_container, grid)

func tile_pos_to_screen_space(tile_pos: Vector2i) -> Vector2i:
	return tile_pos * tile_size

func _init_tiles(chunk_container: Node2D, grid: Dictionary[Array, OMM_TileData]):
	for coord in grid.keys():
		var tile_data = grid[coord]
		var tile := OMM_GroundTile.new_tile(
			tile_pos_to_screen_space(Vector2i(coord[0], coord[1])), 
			score_component,
			tile_data.hardness,
			tile_data.indestructable
		)
		chunk_container.add_child(tile)

		if Engine.is_editor_hint():
			tile.owner = get_tree().edited_scene_root
