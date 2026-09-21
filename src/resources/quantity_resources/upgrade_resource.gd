class_name OMM_UpgradeResource
extends Resource

@export var ending_value: float
@export var steps: int
@export var starting_value: float

signal upgrade_finished()

func upgrade_stat():
	# TODO this math will only approach the starting value but never get there
	var step := (ending_value - starting_value) / steps

	if is_upgrade_finished(step):
		return

	starting_value += step

	if is_upgrade_finished(step):
		upgrade_finished.emit()

	changed.emit()

func is_upgrade_finished(step) -> bool:
	if step < 0:
		return starting_value <= ending_value
	else:
		return starting_value >= ending_value

func get_stat_value():
	return starting_value
