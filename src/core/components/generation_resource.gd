class_name OMM_GenerationResource
extends Resource
var generation = 1

func increment_generation():
	generation =+ 1
	changed.emit(generation)
	
func reset_generation():
	generation = 1
	changed.emit(generation)
