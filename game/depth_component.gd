## Depth currently reached in pixels
class_name OMM_DepthComponent
extends Node

signal changed()

var _depth := 0:
	set(value):
		if _depth != value:
			changed.emit()
		_depth = value

func increment_depth(value = null):
	if value:
		_depth = max(_depth, value)
	else:
		_depth += 1

func get_depth():
	return _depth
