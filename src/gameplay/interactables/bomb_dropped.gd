extends RigidBody2D

@export var explode_timer: Timer
@export var explosion_area: Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode_timer.timeout.connect(explode)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func explode() -> void:
	for tile in explosion_area.get_overlapping_bodies():
		if tile is OMM_GroundTile:
			tile.on_destroy()
	queue_free()
	pass 
