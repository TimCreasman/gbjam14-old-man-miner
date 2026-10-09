class_name OMM_Positions
extends Resource

var _positions: Dictionary[String, bool] = { }


func add_position(position: Vector2):
	_positions.get_or_add(OMM_VectorUtils.hash_vector(position), true)


func has_position(position: Vector2):
	return _positions.has(OMM_VectorUtils.hash_vector(position))
