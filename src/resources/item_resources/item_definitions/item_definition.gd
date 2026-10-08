class_name OMM_ItemDefinition 
extends OMM_Buyable

enum ITEM_TYPES { BOMB, DASH, MIDAS, NONE = -1}

@export var type: ITEM_TYPES
@export var is_unlocked: bool
## value from 0 - 1. 0 is 0% chance 1 is 50% 2 is 75% etc
@export var rarity: float
