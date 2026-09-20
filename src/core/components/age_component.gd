## Age currently reached in years
class_name OMM_AgeResource
extends Resource

var max_age = 150
@export var ages := [0, 25, 50, 75, 100, max_age]

enum AGES {BABY, YOUNG, MIDDLE, OLD, ANCIENT, HISTORY }

signal aged(current_age: AGES)
signal died()

var is_dead = false

var _age := 0:
	set(value):
		if value >= ages[ages.size() - 1]:
			is_dead = true
			died.emit()

		if _age != value:
			aged.emit(int(remap(value, 0, max_age, 0, ages.size())) as AGES)
			changed.emit(value)

		_age = value

func increment_age():
	if is_dead:
		return

	_age += 1

func get_depth():
	return _age

func make_young():
	_age = 0

func die():
	_age = ages[AGES.HISTORY]
