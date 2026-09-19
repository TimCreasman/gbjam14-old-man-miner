extends Panel

@export var current_item: OMM_CurrentItemResource
@export var item_texture_rect: TextureRect

func _ready():
	current_item.item_changed.connect(on_item_changed)

func on_item_changed(definition: OMM_ItemDefinition):
	item_texture_rect.texture = definition.texture
