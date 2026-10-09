class_name OMM_MidasComponent
extends Node2D

@export_group("Internal Components")
@export var midas_timer: Timer
@export var midas_particles: GPUParticles2D
@export var midas_radius: int = 32

var _midas = false


func _ready():
	midas_timer.timeout.connect(stop_midas_touch)


func _physics_process(_delta: float) -> void:
	if !_midas:
		return
	TileMapManager.get_tilemap().over_radius(
		global_position,
		16,
		TileMapManager.get_tilemap().add_gold_tile,
	)


func start_midas() -> void:
	_midas = true
	midas_particles.emitting = true
	midas_timer.start()


func stop_midas_touch() -> void:
	_midas = false
