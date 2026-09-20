class_name OMM_UpgradeResource
extends Resource

@export var min_value: float
@export var max_value: float
@export var step: float

var _stat_value = 0
func _init():
	_stat_value = min_value if step > 0 else max_value

func upgrade():
	if step < 0:
		if _stat_value <= min_value:
			return

	if _stat_value >= max_value:
		return
	_stat_value += step

func get_stat_value():
	return _stat_value
