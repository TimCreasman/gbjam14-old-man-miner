class_name OMM_SparkParticles
extends GPUParticles2D

func start_sparks(pos: Vector2, dir: Vector2):
	emitting = true
	global_position = pos
	process_material.direction = Vector3(dir.x, dir.y, 0)

