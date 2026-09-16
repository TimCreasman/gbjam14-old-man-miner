class_name MusicManager
extends Node2D
var songs ={}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StateManager.state_changed.connect(_on_state_changed)
	for child in get_children():
		if child is AudioStreamPlayer2D:
			songs.set(child.name, child)


func stop_all_songs() -> void:
	for song in songs.values():
		song.stop()

func switch_to_song(name: String) -> void:
	stop_all_songs()
	songs.get(name).play()
	
func _on_state_changed(new_state, old_state) -> void:
	if new_state == "hub":
		switch_to_song("HubTheme")
	if new_state == "shop":
		switch_to_song("ShopTheme")
	if new_state == "mine":
		switch_to_song("MineTheme")
	pass
