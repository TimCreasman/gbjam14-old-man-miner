# @tool
extends Node2D

## Size is in number of tiles
@export var chunk_size: Vector2i = Vector2i.ZERO

@export var chunk_index: int = -1
# @export_custom(PROPERTY_HINT_NONE, "suffix:px") var tile_size: Vector2i = Vector2i(8,8)

@export var depth_component: OMM_DepthComponent
# @export var score_component: OMM_ScoreComponent

@export_category("Internal Components")
@export var chunk_container: CanvasGroup
@export var noise_map: FastNoiseLite

# Turn back on if a tool script
# @export_tool_button("Generate level") var generate_button = _generate
const TILE_SIZE = 8
const DEPTH_OFFSET = 16

func _ready():
	if depth_component:
		depth_component.changed.connect(on_depth_changed)

	_init_chunk()

func on_depth_changed(depth: int):
	depth += DEPTH_OFFSET
	if !_new_chunk_reached(depth):
		return

	chunk_index = _depth_to_chunk_index(depth)

	print("Generating chunk %s" % [chunk_index])
	_init_chunk()

func _new_chunk_reached(depth: int):
	var _new_chunk_index = _depth_to_chunk_index(depth)
	return _new_chunk_index != chunk_index

func _depth_to_chunk_index(depth: float) -> int:
	return ceili(depth / ( chunk_size.y * TILE_SIZE))

func _init_chunk():

	# Get the pixel position
	var y = chunk_index * chunk_size.y * TILE_SIZE
	var chunk_pos = Vector2i(0, y)

	var chunk_bounds = Rect2i(chunk_pos, chunk_size * TILE_SIZE)

	var chunk = OMM_Chunk.create_chunk(chunk_bounds)
	chunk_container.add_child(chunk)
