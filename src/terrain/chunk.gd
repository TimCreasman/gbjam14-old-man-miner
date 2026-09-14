class_name OMM_Chunk
extends Node2D

@export var screen_notifier: VisibleOnScreenNotifier2D

func _ready():
	screen_notifier.screen_exited.connect(queue_free)
