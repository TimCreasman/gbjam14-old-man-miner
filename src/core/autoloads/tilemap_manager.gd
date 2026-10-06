extends Node
var _tilemap: OMM_TileMapGenerator

func get_tilemap() -> OMM_TileMapGenerator:
	return _tilemap

func set_tilemap(tilemap: OMM_TileMapGenerator):
	_tilemap = tilemap
