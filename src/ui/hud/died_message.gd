extends Control

@export var again_button: Button
@export var quit_button: Button
@export var death_label: Label

func _ready():
	SignalBus.player_died.connect(_on_player_died)
	again_button.pressed.connect(_restart)
	quit_button.pressed.connect(_quit)

func _on_player_died(death_message: String):
	again_button.grab_focus()
	death_label.text = death_message
	visible = true

func _restart():
	visible = false
	StateManager.change_state(StateManager.STATE.HUB)
	SignalBus.restarted.emit()

func _quit():
	MusicManager.switch_to_song("ShopTheme")
	get_tree().change_scene_to_file("res://src/ui/end_screen/end_screen.tscn")
