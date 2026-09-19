class_name OMM_ItemDefinition
extends Resource

enum ITEM_TYPES { BOMB, DASH, MIDAS, NONE = -1}

@export var type: ITEM_TYPES
@export var cost: int
@export var is_unlocked: bool
@export var texture: Texture2D
