extends Sprite2D

@export_category("Internal Components")
@export var area_2D: Area2D
@export var particles: GPUParticles2D

func _ready():
	area_2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.has_method("make_young"):
		body.call("make_young")
		particles.emitting = false
		area_2D.queue_free()
