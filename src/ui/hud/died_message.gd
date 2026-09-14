extends Control

@export var age_component: OMM_AgeComponent

func _ready():
	age_component.died.connect(on_died)

func on_died():
	visible = true

func _process(_delta):
	if age_component.is_dead && (Input.is_action_pressed("jump")):
		get_tree().reload_current_scene()
