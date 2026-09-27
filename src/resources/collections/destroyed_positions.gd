class_name OMM_DestroyedPositions
extends Resource

var _positions: Dictionary[String, bool] = {}

func add_position(position: Vector2):
	var normalized = position.snapped(Vector2(8,8))
	_positions.get_or_add(hash_vector(normalized), true)

func has_position(position: Vector2):
	return _positions.has(hash_vector(position))

func hash_vector(position: Vector2i) -> String:
	return (str(position.x) + str(position.y)).sha1_text()
