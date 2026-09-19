class_name OMM_RandomNoise
extends Resource

static var rng = RandomNumberGenerator.new()

static func get_noise_2dv(vector: Vector2i) -> int:
	rng.set_seed(str(vector).hash())
	var random = rng.rand_weighted(PackedFloat32Array([1, 0.1]))
	rng.state = 0
	return random

