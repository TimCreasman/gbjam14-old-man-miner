class_name OMM_TerrainNoise
extends FastNoiseLite

const GROUND_HARDNESS_LEVEL_START = 1
const MAXIMUM_HARDNESS = 10
## At what point is the noise level considered air
const AIR_THRESHOLD = -0.5

func _noise_clamp(noise_level: float) -> int:
	return clampi(remap(noise_level, AIR_THRESHOLD, GROUND_HARDNESS_LEVEL_START, 0, MAXIMUM_HARDNESS), 0, MAXIMUM_HARDNESS)

## Gets the hardness level of the point. 0 is air
func get_ground_hardness(global_pos: Vector2i):
	var noise_level = get_noise_2dv(global_pos)
	return _noise_clamp(noise_level)

func is_ground(position_to_check: Vector2i) -> bool:
	var noise_level = get_noise_2dv(position_to_check)
	return _noise_clamp(noise_level) >= GROUND_HARDNESS_LEVEL_START
