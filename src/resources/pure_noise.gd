class_name OMM_RandomNoise
extends Resource

static var rng = RandomNumberGenerator.new()

static func get_noise_2dv(vector: Vector2i, percent_change = 0.1, seed = 0) -> int:
	rng.set_seed(str(vector).hash() + seed)
	var random = rng.rand_weighted(PackedFloat32Array([1, percent_change]))
	rng.state = 0
	return random

