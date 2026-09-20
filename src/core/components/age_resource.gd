## Age currently reached in years
class_name OMM_AgeResource
extends Resource

var max_age = 150
var _death_reason : DEATH_REASON

@export var ages := [0, 25, 50, 75, 100, max_age]

enum AGES {BABY, YOUNG, MIDDLE, OLD, ANCIENT, HISTORY }

enum DEATH_REASON {OLD_AGE, EXPLOSION, SELF_EXPLOSION}
const DEATH_REASON_READABLE = ["u got old", "u blew up", "u blew urself up"]

signal aged(current_age: AGES)
signal died()

func _init():
	SignalBus.restarted.connect(_reset)

var _death_count = 0

var _is_dead

func get_death_reason():
	return DEATH_REASON_READABLE[_death_reason]

func _reset():
	_is_dead = false
	_age = 0

func get_death_count():
	return _death_count

var _age := 0:
	set(value):
		if _age != value:
			aged.emit(int(remap(value, 0, max_age, 0, ages.size())) as AGES)
			changed.emit(value)

		_age = value

func is_dead():
	if StateManager.is_state(StateManager.STATE.WIN):
		return false

	return _is_dead

func increment_age():
	if _is_dead:
		return

	_age += 1

	if _age >= ages[ages.size() - 1]:
		_die()

func make_young():
	_is_dead = false
	_age = 0

func do_die(death_reason: DEATH_REASON = DEATH_REASON.OLD_AGE):
	_die(death_reason)

func _die(death_reason: DEATH_REASON = DEATH_REASON.OLD_AGE):
	if StateManager.current_state == StateManager.STATE.WIN:
		return
	_death_reason = death_reason
	_death_count += 1
	_is_dead = true
	died.emit(death_reason)
