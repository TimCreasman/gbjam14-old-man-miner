class_name OMM_Chunk
extends Node2D

@export var screen_notifier: VisibleOnScreenNotifier2D
@export var noise: FastNoiseLite

var bounds: Rect2i

static var chunk_scene := preload("res://src/terrain/chunk.tscn")
static func create_chunk(rect: Rect2i) -> OMM_Chunk:
	var chunk: OMM_Chunk = chunk_scene.instantiate()
	chunk.bounds = rect
	return chunk

const TILE_SIZE = 8

func _ready():
	position = bounds.position

	screen_notifier.rect = bounds
	screen_notifier.screen_exited.connect(queue_free)

	_generate()

func _generate():
	for x in range(0, bounds.size.x, TILE_SIZE):
		for y in range(0, bounds.size.y, TILE_SIZE):
			_generate_tile(Vector2i(x, y))

func _generate_tile(tile_position: Vector2i):

	var indestructable = (tile_position.x == 0 || tile_position.x == (bounds.size.x - TILE_SIZE))
	var noise_level = noise.get_noise_2d(tile_position.x, tile_position.y + bounds.position.y)
	var hardness = floori(remap(noise_level, -1, 1, -1, 10))
	var tile := OMM_GroundTile.new_tile(
		tile_position,
		hardness,
		indestructable
	)
	add_child(tile)
