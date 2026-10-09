extends Node2D

signal state_changed

enum STATE {
	MINE,
	SHOP,
	HUB,
	WIN,
}

var current_state: STATE


func change_state(new_state: STATE) -> void:
	var old_state = current_state
	current_state = new_state
	state_changed.emit(new_state, old_state)


func is_state(state: STATE) -> bool:
	return current_state == state
