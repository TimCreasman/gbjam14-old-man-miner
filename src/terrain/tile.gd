@tool
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

var score_component: OMM_ScoreComponent

var _indestructable = false
var _is_gold := false

static var tile_scene := preload("res://src/terrain/tile.tscn")
static func new_tile(pos: Vector2i, _score_component: OMM_ScoreComponent, _hardness := 0, indestructable = false) -> OMM_GroundTile:
	var tile: OMM_GroundTile = tile_scene.instantiate()
	tile.global_position = pos

	tile.hardness = _hardness
	if !indestructable:
		tile._is_gold = _hardness >= 9
	tile._indestructable = indestructable
	tile.score_component = _score_component

	return tile

func _ready():
	if !_indestructable:
		breaking_animation_sprite.animation_finished.connect(breaking_done)
	gold_sprite.visible = _is_gold
	update_hardness_sprite()

func do_break():
	if breaking_animation_sprite.is_playing():
		return
	breaking_animation_sprite.play("breaking_animation")

func update_hardness_sprite():
	hardness_sprite.frame = hardness

func breaking_done():
	do_damage()
	update_hardness_sprite()

func on_destroy():
	queue_free()
	if _is_gold:
		score_component.increment_score()
		_is_gold = false
	propagate_destroy.call_deferred()

func do_damage():
	hardness -= 1

	if hardness == 0:
		on_destroy()

# Hack to expose more area
func propagate_destroy():
	if !neighbor_area.monitoring:
		return

	for neighbor in neighbor_area.get_overlapping_bodies():
		if neighbor is OMM_GroundTile:
			if neighbor.hardness <= 0:
				neighbor.on_destroy()

	# Turn off monitoring
	neighbor_area.monitoring = false
	neighbor_area.monitorable = false
