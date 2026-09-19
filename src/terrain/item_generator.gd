class_name OMM_ItemGenerator
extends Node2D

@export var terrain_noise: OMM_TerrainNoise
@export var picked_up_items: OMM_DestroyedPositions

var pickup_scene = preload("res://src/gameplay/interactables/pickup.tscn")

var item_definitions: Array[OMM_ItemDefinition] = [
	preload("res://src/resources/item_definitions/bomb_definition.tres"),
	preload("res://src/resources/item_definitions/midas_definition.tres"),
	preload("res://src/resources/item_definitions/dash_definition.tres"),
]

var item_index = 0

func sparse_noise_at(global_pos: Vector2, rarity: float):
	return OMM_RandomNoise.get_noise_2dv(global_pos, rarity, 1)

func generate(global_pos: Vector2i):
	if picked_up_items.has_position(global_pos):
		return

	# If below me is not ground, or above me is not air return
	if !terrain_noise.is_ground(global_pos + Vector2i(0, 8)) || terrain_noise.is_ground(global_pos + Vector2i(0, -8)):
		return

	var item_to_spawn = item_definitions[item_index]

	if !sparse_noise_at(global_pos, item_to_spawn.rarity):
		return

	var item_name = "itm" + str(global_pos).sha1_text()
	if !has_node(item_name):

		var item_scene = pickup_scene.instantiate() as OMM_Pickup
		# pickup.definition = bomb_definition
		item_scene.position = global_pos
		item_scene.name = item_name
		item_scene.set_definition(item_to_spawn)
		add_child(item_scene)

		item_index += 1
		item_index %= item_definitions.size()
