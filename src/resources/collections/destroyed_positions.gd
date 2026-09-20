class_name OMM_DestroyedPositions
extends Resource

var _positions: Array[Vector2i] = []

func add_position(position: Vector2):
	var normalized = position.snapped(Vector2(8,8))
	_positions.append(normalized)

func has_position(position: Vector2):
	return _positions.has(position)
