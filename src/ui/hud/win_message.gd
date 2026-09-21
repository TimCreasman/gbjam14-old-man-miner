extends Control
@export var victory_timer: Timer
func _ready():
	victory_timer.timeout.connect(_to_end_screen)
	StateManager.state_changed.connect(_on_state_changed)


func _on_state_changed(state: StateManager.STATE, _old_state: StateManager.STATE):
	if state == StateManager.STATE.WIN:
		visible = true
		victory_timer.start()
	
func _to_end_screen() -> void:
	MusicManager.switch_to_song("ShopTheme")
	get_tree().change_scene_to_file("res://src/ui/end_screen/end_screen.tscn")
	pass
