class_name OMM_Chunk
extends Node2D

@export var screen_notifier: VisibleOnScreenNotifier2D
@export var noise: Noise

var bounds: Rect2i
var rng = RandomNumberGenerator.new()

@export_category("Internal Components")
@export var item_container : Node2D
@export var destroyed_tiles : OMM_DestroyedPositions
@export var structure_generator : OMM_StructureGenerator

static var chunk_scene := preload("res://src/terrain/chunk.tscn")
static func create_chunk(rect: Rect2i, _item_container: Node2D) -> OMM_Chunk:
	var chunk: OMM_Chunk = chunk_scene.instantiate()
	chunk.bounds = rect
	chunk.item_container = _item_container
	return chunk

const TILE_SIZE = 8

func _ready():
	position = bounds.position

	screen_notifier.rect = Rect2(Vector2.ZERO, bounds.expand(Vector2i(-16, 16)).size)
	screen_notifier.screen_exited.connect(reset_all_to_pool)

	structure_generator.set_spawn_container(item_container)

	_generate()

func _generate():
	for x in range(bounds.position.x, bounds.position.x + bounds.size.x, TILE_SIZE):
		for y in range(bounds.position.y, bounds.position.y + bounds.size.y, TILE_SIZE):
			_generate_tile(Vector2i(x, y))
			structure_generator.generate(Vector2i(x, y))
			# _generate_items(Vector2i(x, y))

func _hardness(global_pos: Vector2i):
	var noise_level = noise.get_noise_2dv(global_pos)
	return clampi(remap(noise_level, -0.5, 1, 0, 10), 0, 10)

# Generate noise for items
# func _item_noise_clamp(global_pos: Vector2i):
# 	var noise_level = structure_noise.get_noise_2dv(global_pos)
# 	return clampi(remap(noise_level, -1, 1, 0, 1), 0, 1)

func _generate_tile(global_pos: Vector2i):
	if destroyed_tiles.has_position(global_pos):
		return

	var hardness = _hardness(global_pos)
	if hardness <= 0:
		return

	var tile = OMM_ObjectPool.pull_from_pool({
		"position" : global_pos - bounds.position,
		"hardness" : hardness,
		"indestructable" : false
	})

	add_child.call_deferred(tile)

func reset_all_to_pool():
	for tile in get_children():
		if tile is OMM_GroundTile:
			remove_child(tile)
			OMM_ObjectPool.add_to_pool(tile)

	queue_free()
