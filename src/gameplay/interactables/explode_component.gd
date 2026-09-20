class_name OMM_ExplodeComponent
extends Node2D
@export var explosion_particles: GPUParticles2D
@export var explosion_area: Area2D


signal exploded()

func explode(death_reason: OMM_AgeResource.DEATH_REASON = OMM_AgeResource.DEATH_REASON.EXPLOSION) -> void:
	print(explosion_area.get_overlapping_bodies().size())
	for body in explosion_area.get_overlapping_bodies():

		if body.has_method("do_kill"):
			body.call("do_kill", death_reason)

		if body is OMM_GroundTile:
			body.on_destroy()
			# await tile.destroyed

	explosion_particles.emitting = true
	await explosion_particles.finished

	exploded.emit()
