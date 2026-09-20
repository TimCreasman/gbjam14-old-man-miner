## Age currently reached in years
class_name OMM_AgeResource
extends Resource

var max_age = 150
var _death_reason : DEATH_REASON

@export var ages := [0, 25, 50, 75, 100, max_age]

enum AGES {BABY, YOUNG, MIDDLE, OLD, ANCIENT, HISTORY }

enum DEATH_REASON {OLD_AGE, MINE}
const DEATH_REASON_READABLE = ["u got old", "u blew up"]

signal aged(current_age: AGES)
signal died()

func _init():
	SignalBus.restarted.connect(_reset)

var is_dead:
	get():
		return _age >= ages[ages.size() - 1]

func get_death_reason():
	return DEATH_REASON_READABLE[_death_reason]

func _reset():
	_age = 0

var _age := 0:
	set(value):
		if value >= ages[ages.size() - 1]:
			died.emit()

		if _age != value:
			aged.emit(int(remap(value, 0, max_age, 0, ages.size())) as AGES)
			changed.emit(value)

		_age = value

func increment_age(age_reason: DEATH_REASON = DEATH_REASON.OLD_AGE):
	if is_dead:
		_death_reason = age_reason
		return

	_age += 1

func get_depth():
	return _age

func make_young():
	_age = 0

func die():
	_age = ages[AGES.HISTORY]
