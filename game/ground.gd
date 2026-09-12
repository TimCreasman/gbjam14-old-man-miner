class_name OMM_GroundTile
extends StaticBody2D

@export_range(0, 10, 1) var hardness = 0:
	set(value):
		hardness = clampi(value, 0, 10)

@export_category("Internal Components")
@export var break_timer: Timer
@export var breaking_animation_sprite: AnimatedSprite2D
@export var number_sprite: Sprite2D

@export var neighbor_area: Area2D

func _ready():
	breaking_animation_sprite.animation_finished.connect(breaking_done)
	update_number()

func do_break():
	if breaking_animation_sprite.is_playing():
		return
	breaking_animation_sprite.play("breaking_animation")


func update_number():
	number_sprite.frame = hardness

func breaking_done():
	do_damage()
	update_number()

func destroy():
	queue_free()
	propagate_destroy.call_deferred()

func do_damage():
	hardness -= 1

	if hardness == 0:
		destroy()

func propagate_destroy():
	if !neighbor_area.monitoring:
		return

	for neighbor in neighbor_area.get_overlapping_bodies():
		if neighbor is OMM_GroundTile:
			if neighbor.hardness <= 0:
				neighbor.destroy()

	# Turn off monitoring
	neighbor_area.monitoring = false
	neighbor_area.monitorable = false
