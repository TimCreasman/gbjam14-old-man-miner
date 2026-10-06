class_name OMM_GoldTile
extends Node2D

@export var score_resource: OMM_ScoreResource
@export var gold_sound: AudioStreamPlayer2D

func do_destroy():
	hide()
	score_resource.increment_score()
	gold_sound.play()
	await gold_sound.finished
	queue_free()
