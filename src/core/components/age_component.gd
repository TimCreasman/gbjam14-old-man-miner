## Age currently reached in years
class_name OMM_AgeComponent
extends Node

signal changed(new_value)

var _age := 0:
	set(value):
		if _age != value:
			changed.emit(value)
		_age = value

func increment_age():
	_age += 1

func get_depth():
	return _age
