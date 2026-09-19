class_name OMM_ObjectPool
extends Resource

var _pool: Array[OMM_GroundTile] = []

## Default tile definition
static var default_tile_properties = {
	"name": "inactive",
	"global_position": Vector2(0, -8),
	"hardness": 0,
	"indestructable": true,
	"visible": false,
	"process_mode": Node.PROCESS_MODE_DISABLED
}

static var tile_scene := preload("res://src/terrain/world/tiles/tile.tscn")
static func new_tile() -> OMM_GroundTile:
	var tile: OMM_GroundTile = tile_scene.instantiate()
	tile.reset_properties(default_tile_properties)
	return tile

var _object_pool_node: Node2D
func set_object_pool_node(node: Node2D):
	_object_pool_node = node

func pre_populate_pool():
	for i in range(22 * 20):
		instantiate_tile()

func instantiate_tile():
	var tile = new_tile()
	# tile.add_to_group("inactive")
	_pool.append(tile)
	if _object_pool_node:
		_object_pool_node.add_child(tile)

func pull_from_pool(initial_properties: Dictionary) -> OMM_GroundTile:
	var tile: OMM_GroundTile
	if _pool.is_empty():
		instantiate_tile()

	tile = _pool.pop_back()

	# Apply input settings to the tile
	initial_properties.set("visible", true)
	initial_properties.set("process_mode", Node.PROCESS_MODE_INHERIT)
	tile.reset_properties(initial_properties)

	return tile

func add_to_pool(tile: OMM_GroundTile):
	if !tile:
		return

	tile.global_position = Vector2.ZERO
	tile.reset_properties(default_tile_properties)
	_pool.push_back(tile)
