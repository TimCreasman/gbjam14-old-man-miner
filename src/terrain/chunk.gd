class_name OMM_Chunk
extends Node2D

@export var screen_notifier: VisibleOnScreenNotifier2D
@export var noise_map: NoiseTexture2D

var bounds: Rect2i

var rng = RandomNumberGenerator.new()

@export var item_container : Node2D

static var chunk_scene := preload("res://src/terrain/chunk.tscn")
static func create_chunk(rect: Rect2i, _item_container: Node2D) -> OMM_Chunk:
	var chunk: OMM_Chunk = chunk_scene.instantiate()
	chunk.bounds = rect
	chunk.item_container = _item_container
	return chunk

const TILE_SIZE = 8

var pickup_scene = preload("res://src/gameplay/interactables/pickup.tscn")
var bomb_definition = preload("res://src/resources/bomb_definition.tres")

func _ready():
	position = bounds.position

	screen_notifier.rect = Rect2(Vector2.ZERO, bounds.size)
	screen_notifier.screen_exited.connect(reset_all_to_pool)

	_generate()

func _generate():
	print("%s Generating tiles" % name)
	for x in range(0, bounds.size.x, TILE_SIZE):
		for y in range(0, bounds.size.y, TILE_SIZE):
			_generate_tile(Vector2i(x, y))
			_generate_items(Vector2i(x, y))

func _hardness(pos: Vector2i):
	var noise_level = noise_map.noise.get_noise_2d(pos.x, pos.y + bounds.position.y)
	return floori(remap(noise_level, 0, 1, 0, 10))

func _generate_tile(tile_position: Vector2i):
	var indestructable = (tile_position.x == 0 || tile_position.x == (bounds.size.x - TILE_SIZE))
	var hardness = _hardness(tile_position)

	var tile = OMM_ObjectPool.get_tile()

	if !tile:
		return

	tile.position = tile_position
	tile.hardness = hardness
	tile._indestructable = indestructable
	if !indestructable:
		tile._is_gold = hardness >= 9

	add_child(tile)

func _generate_items(pos: Vector2i):

	var hardness = _hardness(pos)
	if hardness == 0 && rng.randi_range(0, 1) == 1:
		var pickup = pickup_scene.instantiate() as OMM_Pickup
		pickup.definition = bomb_definition
		pickup.position = pos
		item_container.add_child(pickup)

func reset_all_to_pool():
	var count = 0
	for tile in get_children():
		if tile is OMM_GroundTile:
			OMM_ObjectPool.pool_tile(tile)
			count += 1

	print_debug("Chunk: %s is resetting %s tiles to the pool" % [name, count])

	queue_free()
