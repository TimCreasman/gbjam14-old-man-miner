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

var score_component: OMM_ScoreComponent
var indestructable = false
var _is_gold: bool: 
	get():
		return hardness >= 9

signal pool_me(body: OMM_GroundTile)

func _ready():
	on_screen_notifier.screen_exited.connect(_on_screen_exit)

## Takes place of _ready since this a pooled object
func reset_properties(properties: Dictionary):
	for key in properties.keys():
		set(key, properties[key])

	gold_sprite.visible = _is_gold
	update_hardness_sprite()

	# Reset signal connections
	if breaking_animation_sprite.animation_finished.is_connected(breaking_done):
		breaking_animation_sprite.animation_finished.disconnect(breaking_done)

	if !indestructable:
		breaking_animation_sprite.animation_finished.connect(breaking_done)

func do_break(dig_speed):
	if breaking_animation_sprite.is_playing() || !get_parent():
		return
	break_sound.play()
	breaking_animation_sprite.play("breaking_animation")
	breaking_animation_sprite.speed_scale = dig_speed * 10

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
	if indestructable:
		return

	# destroy_sound.play()
	
	if _is_gold:
		# score_component.increment_score()
		gold_sound.play()
		print("GOLD")
		await gold_sound.finished
		# _is_gold = false
	# await destroy_sound.finished

	destroyed_positions.add_position(global_position)

	pool_me.emit(self)

	# propagate_destroy()

func do_damage():
	
	hardness -= 1

	if hardness == 0:
		on_destroy()

# Hack to expose more area
func propagate_destroy():
	if !neighbor_area.monitoring:
		return
	var bodies = neighbor_area.get_overlapping_bodies()
	neighbor_area.monitoring = false
	neighbor_area.monitorable = false

	for neighbor in bodies:
		if neighbor is OMM_GroundTile:
			if neighbor.hardness <= 0:
				neighbor.on_destroy()

	# Turn off monitoring
	neighbor_area.monitoring = false
	neighbor_area.monitorable = false

func _on_screen_exit():
	pool_me.emit(self)
