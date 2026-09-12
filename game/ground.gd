class_name OMM_GroundTile
extends StaticBody2D

@export_range(0, 10, 1) var hardness = 0

func _ready():
	$TileMapLayer.set_cell(Vector2i.ZERO, 0, Vector2i(hardness, 0), 0)

@export_category("Internal Components")
@export var break_timer: Timer
