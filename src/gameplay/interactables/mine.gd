extends Node2D

@export_category("Internal Components")
@export var area_2d: Area2D
@export var sprite: Sprite2D
@export var triggered_sound: AudioStreamPlayer2D
@export var explode_component: OMM_ExplodeComponent
@export var destroyed_structures: OMM_DestroyedPositions

func _ready():
	area_2d.body_exited.connect(_on_body_exited)
	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D):
	sprite.hide()
	triggered_sound.play()

func _on_body_exited(_body: Node2D):
	explode_component.explode()

	await explode_component.exploded

	destroyed_structures.add_position(global_position)

	queue_free()
