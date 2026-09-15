extends Node2D

@export var definition: OMM_ItemDefinition

@export_category("Internal components")
@export var sprite_2d: Sprite2D
@export var area_2d: Area2D

func _ready():
	sprite_2d.texture = definition._texture
	area_2d.body_entered.connect(grant_pickup)

func grant_pickup(body: Node2D):
	if body.has_method("pickup"):
		body.pickup(definition.type)
		queue_free()
