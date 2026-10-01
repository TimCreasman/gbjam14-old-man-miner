class_name OMM_ObjectPool
extends Object

var _pool: Array[OMM_GroundTile] = []

var _default_properties: Dictionary = {}
var _pooled_node_scene: PackedScene = null
var _container_node: Node2D
var _pool_location = Vector2.ZERO

static var _ensured_default_properties = {
	"visible": false,
	"process_mode": Node.PROCESS_MODE_DISABLED
}

static var _ensured_initial_properties = {
	"visible": true,
	"process_mode": Node.PROCESS_MODE_INHERIT
}

# TODO if we want more than one active pool, change this
static var ACTIVE_GROUP = "active"

## Pull a node from the object pool. Optionally supply a list of initial properties for the node.
## `visible` and `process_mode` properties are always enabled
func pull_from_pool(initial_properties: Dictionary = {}) -> OMM_PooledStaticBody2D:
	var node: OMM_PooledStaticBody2D
	if _pool.is_empty():
		print_debug("Ran out of pooled nodes. Container count: ", _container_node.get_children().size())
		_instantiate_node()

	node = _pool.pop_back()

	initial_properties.merge(_ensured_initial_properties)

	node.reset_properties(initial_properties)
	node.add_to_group(ACTIVE_GROUP)

	return node

func add_to_pool(node: OMM_PooledStaticBody2D):
	if !node:
		return

	node.global_position = _pool_location
	node.reset_properties(_default_properties)
	node.remove_from_group(ACTIVE_GROUP)

	_pool.push_back(node)

func _init(
	starting_population: int, 
	scene_path: NodePath, 
	default_properties: Dictionary,
	container_node: Node2D 
	):

	_pooled_node_scene = load(scene_path)

	_default_properties = default_properties
	_default_properties.merge(_ensured_default_properties)

	_container_node = container_node
	_populate_pool(starting_population)

func _new_node() -> OMM_PooledStaticBody2D:
	var node: OMM_PooledStaticBody2D = _pooled_node_scene.instantiate()
	node.reset_properties(_default_properties)
	return node

func _populate_pool(amount: int):
	for i in range(amount):
		_instantiate_node()

func _instantiate_node():
	var node = _new_node()
	_pool.append(node)
	if _container_node:
		_container_node.add_child(node)
