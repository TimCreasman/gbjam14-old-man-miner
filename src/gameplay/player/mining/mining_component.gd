class_name OMM_MiningComponent
extends Node2D

const directions = {
	&"move_left": Vector2(-1, 0),
	&"move_up": Vector2(0, -1),
	&"move_right": Vector2(1, 0),
	&"move_down": Vector2(0, 1),
}

## Dig speed in seconds
@export var dig_speed: OMM_StatResource
@export var dig_distance = 7

@export_group("Internal Components")
@export var ray_cast: RayCast2D
@export var debug_line: Line2D
@export var mining_animation: OMM_BreakingAnimation
@export var sparks_emitter: OMM_SparkParticles
@export var dig_timer: Timer

var pressed_actions = []


func _ready():
	dig_timer.wait_time = dig_speed.get_stat_value()
	dig_speed.changed.connect(_on_dig_speed_changed)
	mining_animation.hide()
	sparks_emitter.emitting = false


func handle_mine():
	_handle_input()

	if !dig_timer.is_stopped():
		return

	if pressed_actions.is_empty():
		return
	var mine_dir = directions[pressed_actions[-1]]

	ray_cast.target_position = mine_dir * dig_distance
	ray_cast.force_raycast_update()

	if !ray_cast.is_colliding():
		mining_animation.stop_breaking()
		sparks_emitter.emitting = false
		return

	if debug_line:
		debug_line.points[1] = ray_cast.target_position

	mine(mine_dir)


func mine(mine_dir):
	var tile_map = ray_cast.get_collider()
	if tile_map && tile_map is OMM_TileMapGenerator:
		var collision_point = ray_cast.get_collision_point()
		var coords = (ray_cast.global_position + ray_cast.target_position)

		sparks_emitter.start_sparks(collision_point, -mine_dir)
		mining_animation.start_breaking(collision_point, mine_dir)

		dig_timer.start()
		await dig_timer.timeout

		tile_map.break_tile(coords)

		dig_timer.stop()

		mining_animation.stop_breaking()
		sparks_emitter.emitting = false
	pass


func _handle_input():
	for direction in directions:
		if Input.is_action_just_pressed(direction):
			pressed_actions.push_back(direction)
		if Input.is_action_just_released(direction):
			pressed_actions.erase(direction)


func _on_dig_speed_changed():
	dig_timer.wait_time = dig_speed.get_stat_value()
