class_name OMM_VectorUtils

static func hash_vector(position: Vector2i) -> String:
	return (str(position.x) + str(position.y)).sha1_text()
