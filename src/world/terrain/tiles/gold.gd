class_name OMM_GoldTile
extends Node2D

@export var score_resource: OMM_ValueResource
@export var gold_sound: AudioStreamPlayer2D

func do_destroy():
	hide()
	score_resource.increment()
	gold_sound.play()
	await gold_sound.finished
	queue_free()
