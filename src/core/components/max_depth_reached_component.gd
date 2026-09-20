class_name OMM_MaxDepthReachedComponent
extends Node

@export var player_coordinate: OMM_Coordinate
@export var age_component: OMM_AgeResource

@export var half_way_palette: GBPalette
@export var output_palette: GBPalette

var max_depth

signal max_depth_reached()

func _ready():
	player_coordinate.coordinate_changed.connect(_on_coordinate_changed)
	load_cfg()

func load_cfg():
	var world_gen_cfg = ConfigFile.new()
	var err = world_gen_cfg.load("res://src/terrain/world/world_gen.cfg")
	if err!= OK:
		print_debug("Could not load world gen config file")

	max_depth = world_gen_cfg.get_value("main", "max_depth", INF)

func _on_coordinate_changed(coordinate: Vector2i):
	# TODO use TILESIZS
	if coordinate.y >= (max_depth - 80) && !age_component.is_dead():
		StateManager.change_state(StateManager.STATE.WIN)
		max_depth_reached.emit()

	if coordinate.y == (max_depth / 2):
		go_deeper()

func go_deeper():
	output_palette.set_palette(half_way_palette)
	MusicManager.switch_to_song("DeeperTheme")
