class_name OMM_DashParticles
extends GPUParticles2D

func start(pos: Vector2, angle: float):
	emitting = true
	global_position = pos
	process_material.angle_max = angle
	process_material.angle_min = angle
