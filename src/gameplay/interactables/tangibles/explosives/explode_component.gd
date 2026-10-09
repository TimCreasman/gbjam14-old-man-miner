class_name OMM_ExplodeComponent
extends Node2D

signal exploded()

@export var explosion_particles: GPUParticles2D
@export var explosion_area: Area2D
@export var explosion_shape: CircleShape2D
@export var explosion_sound: AudioStreamPlayer2D


func explode(
	death_reason: OMM_AgeResource.DEATH_REASON = OMM_AgeResource.DEATH_REASON.EXPLOSION
) -> void:
	# Workaround because overlapping bodies sometimes will not detect the tile map...
	TileMapManager.get_tilemap().remove_radius(global_position, floor(explosion_shape.radius))

	for body in explosion_area.get_overlapping_bodies():
		if body.has_method("do_kill"):
			body.call("do_kill", death_reason)

		if body is OMM_TileMapGenerator:
			body.remove_radius(global_position, explosion_shape.radius)

	if explosion_sound:
		explosion_sound.play()

	explosion_particles.emitting = true
	await explosion_particles.finished

	exploded.emit()
