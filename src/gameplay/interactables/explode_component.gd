class_name OMM_ExplodeComponent
extends Node2D
@export var explosion_particles: GPUParticles2D
@export var explosion_area: Area2D

signal exploded()

func explode() -> void:
	print(explosion_area.get_overlapping_bodies().size())
	for tile in explosion_area.get_overlapping_bodies():
		if tile is OMM_GroundTile:
			tile.on_destroy()
			print(tile)
			# await tile.destroyed

	explosion_particles.emitting = true
	await explosion_particles.finished

	exploded.emit()
