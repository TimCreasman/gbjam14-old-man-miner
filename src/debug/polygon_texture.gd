extends Sprite2D

@export var polygon: Polygon2D


func _process(_delta):
	if polygon:
		texture = polygon.texture
