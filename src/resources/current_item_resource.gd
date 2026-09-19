## Depth currently reached in pixels
class_name OMM_CurrentItemResource
extends Resource

signal item_changed(definition: OMM_ItemDefinition)

@export var definition : OMM_ItemDefinition:
	set(value):
		if value:
			item_changed.emit(value)
		definition = value

