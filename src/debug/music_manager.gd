class_name MusicManager
extends Node2D
var songs ={}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer2D:
			songs.set(child.name, child)
	switch_to_song("HubTheme")


func stop_all_songs() -> void:
	for song in songs.values():
		song.stop()

func switch_to_song(name: String) -> void:
	stop_all_songs()
	songs.get(name).play()
