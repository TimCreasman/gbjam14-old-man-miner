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
	
func _on_state_changed(new_state, _old_state) -> void:
	match new_state:
		StateManager.STATE.HUB:
			switch_to_song("HubTheme")
		StateManager.STATE.SHOP:
			switch_to_song("ShopTheme")
		StateManager.STATE.MINE:
			switch_to_song("MineTheme")
	pass
