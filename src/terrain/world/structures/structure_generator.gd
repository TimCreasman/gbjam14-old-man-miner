class_name OMM_StructureGenerator
extends Node2D

@export var structures: Array[OMM_StructureDefinition] = []
@export var terrain_noise: OMM_TerrainNoise

var _spawn_container: Node2D = self

var structure: OMM_StructureDefinition

@export var destroyed_structures: OMM_DestroyedPositions

func set_spawn_container(container: Node2D):
	_spawn_container = container

func sparse_noise_at(global_pos: Vector2, _seed: int):
	return OMM_RandomNoise.get_noise_2dv(global_pos, 0.1, _seed)

func is_space(rect: Rect2i) -> bool:
	for x in range(rect.position.x, rect.position.x + rect.size.x, 8):
		if !terrain_noise.is_ground(Vector2i(x, rect.position.y + 8)):
			return false

		for y in range(rect.position.y, rect.position.y - rect.size.y, -8):
			if terrain_noise.is_ground(Vector2i(x, y)):
				return false
	return true

func generate(global_pos: Vector2i):
	if !terrain_noise.is_ground(global_pos + Vector2i(0, 8)):
		return
	
	for i in structures.size():
		var structure_to_spawn = structures[i]

		if destroyed_structures.has_position(global_pos):
			continue

		if !sparse_noise_at(global_pos, 1000 * i):
			continue

		var structure_rect = Rect2i(global_pos, structure_to_spawn.size * 8)

		if !is_space(structure_rect):
			continue

		var structure_name = "str" + str(global_pos).sha1_text()
		if !_spawn_container.has_node(structure_name):
			var structure_scene = structure_to_spawn.scene.instantiate()
			# pickup.definition = bomb_definition
			structure_scene.position = global_pos
			structure_scene.name = structure_name
			_spawn_container.add_child(structure_scene)
