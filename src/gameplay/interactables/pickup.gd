class_name OMM_Pickup
extends Node2D

@export var definition: OMM_ItemDefinition
@export var picked_up_items: OMM_DestroyedPositions

@export_category("Internal components")
@export var sprite_2d: Sprite2D
@export var area_2d: Area2D

func _ready():
	sprite_2d.texture = definition.texture
	area_2d.body_entered.connect(grant_pickup)

func set_definition(_definition: OMM_ItemDefinition):
	definition = _definition

func grant_pickup(body: Node2D):
	if body.has_method("pickup"):
		body.pickup(definition)
		picked_up_items.add_position(global_position)
		queue_free()
