
extends Node2D

var states = ["mine", "shop", "hub"]
var current_state: String
signal state_changed

	
func change_state(new_state: String) -> void:
	if new_state in states:
		var old_state = current_state
		current_state = new_state
		state_changed.emit(new_state, old_state)
