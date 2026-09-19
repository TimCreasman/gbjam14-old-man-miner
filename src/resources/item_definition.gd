class_name OMM_ItemDefinition
extends Resource

enum ITEM_TYPES { BOMB, DASH, MIDAS, NONE = -1}

static var item_textures : Array[Texture2D] = [
	preload("res://assets/art/sprites/interactables/bomb.png")
] 



@export var type: ITEM_TYPES
@export var cost: int
@export var is_unlocked: bool

@export var texture := get_texture(type)

static func get_texture(_type: ITEM_TYPES) -> Texture2D:
	if _type == ITEM_TYPES.NONE:
		return
	return item_textures[_type]
