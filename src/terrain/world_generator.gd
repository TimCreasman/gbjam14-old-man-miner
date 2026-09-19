class_name OMM_WorldGenerator
extends Node2D

@export_category("Internal Components")
@export var tile_generator: OMM_TileGenerator

signal generated()

func _ready():
	generated.emit()
