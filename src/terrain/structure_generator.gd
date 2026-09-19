class_name OMM_StructureGenerator
extends Node2D

@export var structures: Array[OMM_StructureDefinition]
@export var noise: Noise
@export var terrain_noise: Noise

var pickup_scene = preload("res://src/gameplay/interactables/pickup.tscn")
var bomb_definition = preload("res://src/resources/bomb_definition.tres")
var _spawn_container: Node2D

var structure: OMM_StructureDefinition

func _ready():
	structure = structures[0]
	pass

func set_spawn_container(container: Node2D):
	_spawn_container = container

func sparse_noise_at(global_pos: Vector2):
	var noise_level = noise.get_noise_2dv(global_pos)
	print(noise_level)
	if noise_level > 0.5:
		return 1
	return 0

func is_space(global_pos: Vector2i, size: Vector2i) -> bool:
	for x in range(1, size.x):
		for y in range(1, size.y):
			if _point_is_ground(global_pos + Vector2i(size.y * 8, size.x * 8)):
				return false
	return true

func _point_is_ground(global_pos: Vector2i):
	var noise_level = terrain_noise.get_noise_2dv(global_pos)
	return clampi(remap(noise_level, -0.5, 1, 0, 10), 0, 10) > 0

# TODO get fountain showing
func generate(global_pos: Vector2i):
	# If below me is not ground, or above me is not air return
	if !_point_is_ground(global_pos + Vector2i(0, 8)) || _point_is_ground(global_pos + Vector2i(0, -8)):
		return

	if !sparse_noise_at(global_pos):
		return

	if !is_space(global_pos, structure.size):
		return

	# print(sparse_noise_at(global_pos))

	var structure_name = str(global_pos).sha1_text()
	if !_spawn_container.has_node(structure_name):
		var structure_scene = structure.scene.instantiate()
		# pickup.definition = bomb_definition
		structure_scene.position = global_pos
		structure_scene.name = structure_name
		_spawn_container.add_child(structure_scene)
