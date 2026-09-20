extends Node2D

@export_category("Internal Components")
@export var area_2d: Area2D
@export var sprite: Sprite2D
@export var explode_component: OMM_ExplodeComponent
@export var destroyed_structures: OMM_DestroyedPositions

func _ready():
	area_2d.body_exited.connect(_on_body_exited)

func _on_body_exited(body: Node2D):
	explode_component.explode()

	await explode_component.exploded

	if body.has_method("do_kill"):
		body.call("do_kill")

	destroyed_structures.add_position(global_position)

	queue_free()
