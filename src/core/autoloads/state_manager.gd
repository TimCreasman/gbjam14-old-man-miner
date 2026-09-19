extends Node2D

var states = ["mine", "shop", "hub"]
enum STATE { MINE, SHOP, HUB } 

var current_state: STATE
signal state_changed

	
func change_state(new_state: STATE) -> void:
	var old_state = current_state
	current_state = new_state
	state_changed.emit(new_state, old_state)
