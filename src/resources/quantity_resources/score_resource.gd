class_name OMM_ScoreResource
extends Resource

var _score: int = 100:
	set(value):
		_score = value
		changed.emit(_score)

var _total_score: int = 0

func get_total_score():
	return _total_score

func increment_score(amount := 1):
	_score += amount
	_total_score += amount

func decrement_score(amount := 1):
	_score -= amount
