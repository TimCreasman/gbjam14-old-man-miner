extends Panel

@export var current_item: OMM_CurrentItemResource
@export var item_texture_rect: TextureRect

func _ready():
	current_item.item_changed.connect(on_item_changed)
	item_texture_rect.texture = OMM_ItemDefinition.get_texture(current_item.type)

func on_item_changed(type: OMM_ItemDefinition.ITEM_TYPES):
	item_texture_rect.texture = OMM_ItemDefinition.get_texture(type)
