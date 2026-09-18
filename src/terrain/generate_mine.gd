# @tool
extends Node2D

## Size is in number of tiles
@export var chunk_size: Vector2i = Vector2i.ZERO

# @export_custom(PROPERTY_HINT_NONE, "suffix:px") var tile_size: Vector2i = Vector2i(8,8)

@export var player_coordinate: OMM_Coordinate
# @export var score_component: OMM_ScoreComponent

@export_category("Internal Components")
@export var chunk_container: CanvasGroup

@export var item_container: Node2D

@export var noise_map: FastNoiseLite

# Turn back on if a tool script
# @export_tool_button("Generate level") var generate_button = _generate
const TILE_SIZE = 8
const DEPTH_OFFSET = 16

func _ready():
	if player_coordinate:
		player_coordinate.coordinate_changed.connect(on_coordinate_changed)

	_init_chunk(Vector2i(0, 0))

func on_coordinate_changed(coordinate: Vector2i):
	# Look at surrounding chunks and generate
	var current_index = coordinate_to_chunk_index(coordinate)

	for x in range(-5, 5):
		for y in range(-7, 7):
			_init_chunk(current_index + Vector2i(x, y))

func coordinate_to_chunk_pos(coordinate: Vector2i):
	return coordinate * chunk_size * TILE_SIZE

func coordinate_to_chunk_index(coordinate: Vector2i):
	return coordinate / chunk_size / TILE_SIZE

func _depth_to_chunk_index(depth: float) -> int:
	return ceili(depth / ( chunk_size.y * TILE_SIZE))

func _init_chunk(chunk_index: Vector2i):
	var chunk_pos = chunk_index * chunk_size * TILE_SIZE
	var chunk_id = str(chunk_index).sha1_text()

	if chunk_container.has_node(chunk_id) || chunk_pos.y < 144:
		return

	var chunk_bounds = Rect2i(chunk_pos, chunk_size * TILE_SIZE)
	var chunk = OMM_Chunk.create_chunk(chunk_bounds, item_container)

	chunk.name = str(chunk_index).sha1_text()
	chunk_container.add_child(chunk)
