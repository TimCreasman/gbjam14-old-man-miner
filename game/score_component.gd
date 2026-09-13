class_name OMM_ScoreComponent
extends Node

signal changed(new_value)

var _score: int = 0

func increment_score(amount := 1):
	_score += amount
	changed.emit(_score)

