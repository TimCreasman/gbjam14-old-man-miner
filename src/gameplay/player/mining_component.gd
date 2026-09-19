class_name OMM_MiningComponent
extends Node2D
@export var ray_cast: RayCast2D

## Dig speed in seconds
@export var dig_speed: float = 1.0

func handle_mine():
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir.is_zero_approx():
		return

	ray_cast.rotation = move_dir.angle()

	var tile = ray_cast.get_collider()
	if tile && tile.has_method("do_break"):
		tile.do_break(dig_speed)
		if StateManager.current_state != StateManager.STATE.MINE && StateManager.current_state != StateManager.STATE.WIN:
			StateManager.change_state(StateManager.STATE.MINE)
