class_name OMM_ScoreResource
extends Resource

var _score: int = 0

func increment_score(amount := 1):
	_score += amount
	changed.emit(_score)
