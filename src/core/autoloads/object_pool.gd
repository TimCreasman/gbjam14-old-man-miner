extends Node

var _tile_pool: Array[OMM_GroundTile] = []

## 100 tiles long
const MAP_LENGTH = 100

func _ready():
	populate_pool()

func populate_pool():
	for i in range(30 * MAP_LENGTH):
		instantiate_tile(i)

func instantiate_tile(index: int):
	var tile = OMM_GroundTile.new_tile(Vector2(0, -8), 0, true)
	tile.visible = false
	tile.process_mode = Node.PROCESS_MODE_DISABLED
	tile.name = str(index)
	_tile_pool.append(tile)

func get_tile() -> OMM_GroundTile:
	var tile = _tile_pool.pop_back()
	if !tile:
		return null

	tile.visible = true
	tile.process_mode = Node.PROCESS_MODE_INHERIT
	return tile

func pool_tile(tile: OMM_GroundTile):
	# Detach child from parent
	if tile.get_parent():
		tile.get_parent().remove_child(tile)

	tile.visible = false
	tile.position = Vector2(0, -8)
	tile.process_mode = Node.PROCESS_MODE_DISABLED
	_tile_pool.push_back(tile)
