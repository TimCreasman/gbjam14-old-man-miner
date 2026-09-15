## Depth currently reached in pixels
class_name OMM_CurrentItemResource
extends Resource

signal item_changed(type: OMM_ItemDefinition.ITEM_TYPES)

@export var type := OMM_ItemDefinition.ITEM_TYPES.NONE:
	set(value):
		item_changed.emit(value)
		type = value

