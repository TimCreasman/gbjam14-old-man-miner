class_name OMM_DashComponent
extends Node2D

@export var dasher: CharacterBody2D

@export_group("Internal Components")
@export var dash_timer: Timer
@export var dash_circle: CircleShape2D
@export var dash_particles: OMM_DashParticles

var is_dashing:
	get():
		return _dashing
var _dashing = false


func _ready():
	dash_timer.timeout.connect(_stop_dashing)


func _physics_process(_delta: float) -> void:
	if !_dashing:
		return
	dash_particles.start(global_position, dasher.velocity.angle())
	TileMapManager.get_tilemap().remove_radius(global_position, floor(dash_circle.radius))


func start_dash():
	_dashing = true
	dash_timer.start()


func _stop_dashing():
	dash_particles.emitting = false
	_dashing = false
