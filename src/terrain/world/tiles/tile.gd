class_name OMM_GroundTile
extends StaticBody2D

@export_range(0, 10, 1) var hardness = 0:
	set(value):
		if value == null:
			return
		hardness = clampi(value, 0, 10)

@export_category("Internal Components")
@export var break_timer: Timer
@export var breaking_animation_sprite: AnimatedSprite2D
@export var hardness_sprite: Sprite2D
@export var gold_sprite: Sprite2D
@export var neighbor_area: Area2D
@export var gold_sound: AudioStreamPlayer2D
@export var break_sound: AudioStreamPlayer2D
@export var destroy_sound: AudioStreamPlayer2D
@export var on_screen_notifier: VisibleOnScreenNotifier2D

@export var destroyed_positions: OMM_DestroyedPositions

@export var score_resource: OMM_ScoreResource
var indestructable = false

var _is_gold: bool

signal pool_me(body: OMM_GroundTile)

func _ready():
	on_screen_notifier.screen_exited.connect(_on_screen_exit)

## Takes place of _ready since this a pooled object
func reset_properties(properties: Dictionary):
	for key in properties.keys():
		set(key, properties[key])

	_is_gold = hardness >= 9
	gold_sprite.visible = _is_gold
	update_hardness_sprite()

	# Reset signal connections
	if break_timer.timeout.is_connected(breaking_done):
		break_timer.timeout.disconnect(breaking_done)

	break_timer.timeout.connect(breaking_done)
	break_timer.stop()

func do_break(time_to_break: float):
	breaking_animation_sprite.speed_scale = 1 / break_timer.wait_time

	if !breaking_animation_sprite.is_playing():
		breaking_animation_sprite.play("breaking_animation")

	if break_timer.time_left:
		return

	break_timer.wait_time = time_to_break
	break_timer.start()
	break_sound.play()

func update_hardness_sprite():
	hardness_sprite.frame = hardness

func breaking_done():
	do_damage()

	update_hardness_sprite()

func turn_to_gold() -> void:
	if !_is_gold:
		hardness = 9
		update_hardness_sprite()
		gold_sprite.visible = _is_gold
	
func on_destroy():

	destroy_sound.play()
	await destroy_sound.finished
	
	if _is_gold:
		score_resource.increment_score()
		gold_sound.play()
		await gold_sound.finished

	destroyed_positions.add_position(global_position)

	pool_me.emit(self)

	# propagate_destroy()

func do_damage():
	
	hardness -= 1

	if hardness == 0:
		on_destroy()

func _on_screen_exit():
	pool_me.emit(self)
