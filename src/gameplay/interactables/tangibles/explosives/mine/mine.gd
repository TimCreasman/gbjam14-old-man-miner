extends Node2D

@export_group("Internal Components")
@export var area_2d: Area2D
@export var sprite: Sprite2D
@export var triggered_sound: AudioStreamPlayer2D
@export var explode_component: OMM_ExplodeComponent


func _ready():
	area_2d.body_exited.connect(_on_body_exited)
	area_2d.body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D):
	sprite.hide()
	triggered_sound.play()


func _on_body_exited(_body: Node2D):
	explode_component.explode()

	await explode_component.exploded

	queue_free()
