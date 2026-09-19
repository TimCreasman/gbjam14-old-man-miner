extends Node2D

enum STATE { MINE, SHOP, HUB, WIN} 

var current_state: STATE
signal state_changed
	
func change_state(new_state: STATE) -> void:
	var old_state = current_state
	current_state = new_state
	state_changed.emit(new_state, old_state)
