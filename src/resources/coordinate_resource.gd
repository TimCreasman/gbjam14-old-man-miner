class_name OMM_Coordinate
extends Resource

@export var output_palette: GBPalette

signal coordinate_changed(coordinate)

# clamps to tile size coordinate (8, 8)
var coordinate: Vector2i:
	set(value):
		var snapped_coordinate = value.snappedi(8)
		if snapped_coordinate != coordinate:
			coordinate = snapped_coordinate
			coordinate_changed.emit(coordinate)
