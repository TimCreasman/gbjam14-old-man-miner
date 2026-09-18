extends Node

@export var pause_menu: CanvasLayer

func _ready() -> void:
	StateManager.change_state(StateManager.STATE.HUB)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	var tree = get_tree()
	tree.paused = !tree.paused
	pause_menu.visible = tree.paused
	
