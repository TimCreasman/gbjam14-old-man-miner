extends RigidBody2D

@export_category("Internal Components")
@export var explode_timer: Timer
@export var explosion_area: Area2D
@export var sprite: AnimatedSprite2D
@export var explosion_particles: GPUParticles2D

func _ready() -> void:
	explode_timer.timeout.connect(explode)

func explode() -> void:
	sprite.play("explode")
	await sprite.animation_finished

	for tile in explosion_area.get_overlapping_bodies():
		if tile is OMM_GroundTile:
			tile.on_destroy()
	# Hide sprite
	sprite.visible = false
	# animated gpu
	explosion_particles.emitting = true
	await explosion_particles.finished

	queue_free()
