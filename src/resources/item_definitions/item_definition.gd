class_name OMM_ItemDefinition
extends Resource

enum ITEM_TYPES { BOMB, DASH, MIDAS, NONE = -1}

@export var type: ITEM_TYPES
@export var cost: int
@export var is_unlocked: bool
@export var texture: Texture2D
## value from 0 - 1. 0 is 0% chance 1 is 50% 2 is 75% etc
@export var rarity: float
