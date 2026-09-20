extends RigidBody2D

@export_category("Internal Components")
@export var explode_component: OMM_ExplodeComponent
@export var sprite: AnimatedSprite2D
@export var explode_timer: Timer

func _ready() -> void:
	explode_timer.timeout.connect(_on_explode_timer)

func _on_explode_timer() -> void:

	sprite.play("explode")
	await sprite.animation_finished

	explode_component.explode()

	sprite.visible = false

	await explode_component.exploded

	queue_free()
