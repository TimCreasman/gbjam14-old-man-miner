class_name OMM_DeathComponent
extends Node2D

var death_container: Node2D
var age_component: OMM_AgeResource

var sprite_scene = preload("res://src/gameplay/player/player_sprite.tscn")

func set_up(_death_container, _age_component):
	death_container = _death_container
	age_component = _age_component
	age_component.died.connect(on_died)

func on_died():
	var sprite = sprite_scene.instantiate() as Sprite2D
	sprite.frame = 5
	sprite.position = global_position
	death_container.add_child(sprite)
