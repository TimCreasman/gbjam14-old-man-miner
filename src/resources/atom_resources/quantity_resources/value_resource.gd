## Keeps track of a value and its running total
class_name OMM_ValueResource
extends Resource

var _value: int = 0:
	set(value):
		if value != _value:
			changed.emit(value)
		_value = value

var _total_value: int = 0


func get_total():
	return _total_value


func get_value():
	return _value


func reset_value():
	_value = 0


func increment(amount := 1):
	_value += amount
	_total_value += amount


func decrement(amount := 1):
	_value -= amount
