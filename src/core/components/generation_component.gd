class_name OMM_GenerationComponent
extends Node
signal changed(new_value)
var generation = 1

func increment_generation():
	generation =+ 1
	changed.emit(generation)
	
func reset_generation():
	generation = 1
	changed.emit(generation)
