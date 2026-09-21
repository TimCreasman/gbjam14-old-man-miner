class_name OMM_MaxDepthReachedComponent
extends Node

@export var player_coordinate: OMM_Coordinate
@export var age_component: OMM_AgeResource

@export var level_0_palette: GBPalette
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
	StateManager.state_changed.connect(_on_state_changed)

func _on_state_changed(new_state, _old_state):
	if new_state == StateManager.STATE.HUB:
		output_palette.set_palette(level_0_palette)

func _on_coordinate_changed(coordinate: Vector2i):
	if coordinate.y == 144:
		if !StateManager.is_state(StateManager.STATE.MINE):
			StateManager.change_state(StateManager.STATE.MINE)

	if coordinate.y == (max_depth / 2):
		go_deeper()
	# TODO use TILESIZS
	if coordinate.y == (max_depth - 80) && !age_component.is_dead():
		bottom_reached()

func go_deeper():
	output_palette.set_palette(half_way_palette)
	MusicManager.switch_to_song("DeeperTheme")

func bottom_reached():
	StateManager.change_state(StateManager.STATE.WIN)
	output_palette.lighten(0.3)
	MusicManager.switch_to_song("TheBottomTheme")
	max_depth_reached.emit()
