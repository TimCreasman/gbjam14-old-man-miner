extends Node

var _pool: Array[OMM_GroundTile] = []

## 100 tiles long
const MAP_LENGTH = 100

## Default tile definition
static var default_tile_properties = {
	"global_position": Vector2(0, -8),
	"hardness": 0,
	"indestructable": true,
	"visible": false,
	"process_mode": Node.PROCESS_MODE_DISABLED
}

static var tile_scene := preload("res://src/terrain/tile.tscn")
static func new_tile() -> OMM_GroundTile:
	var tile: OMM_GroundTile = tile_scene.instantiate()
	tile.reset_properties(default_tile_properties)
	return tile

func _ready():
	populate_pool()

func populate_pool():
	for i in range(10* MAP_LENGTH):
		instantiate_tile(i)

func instantiate_tile(index: int):
	var tile = new_tile()
	tile.name = str(index)
	_pool.append(tile)

func pull_from_pool(initial_properties: Dictionary) -> OMM_GroundTile:
	var tile: OMM_GroundTile
	if _pool.is_empty():
		tile = instantiate_tile(0)
	else:
		tile = _pool.pop_back()

	_detach_tile(tile)

	# Apply input settings to the tile
	initial_properties.set("visible", true)
	initial_properties.set("process_mode", Node.PROCESS_MODE_INHERIT)
	tile.reset_properties(initial_properties)

	return tile

func add_to_pool(tile: OMM_GroundTile):
	if !tile:
		return
		
	_detach_tile(tile)

	tile.reset_properties(default_tile_properties)
	_pool.push_back(tile)

func _detach_tile(tile: OMM_GroundTile):
	if tile.get_parent():
		tile.get_parent().remove_child(tile)
