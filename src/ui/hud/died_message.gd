extends Control

@export var age_component:OMM_AgeResource

func _ready():
	age_component.died.connect(on_died)

func on_died():
	visible = true

## TODO Get loop workgin
func _process(_delta):
	pass
	# if age_component.is_dead && (Input.is_action_pressed("jump")):
	# 	get_tree().reload_current_scene()
	# 	visible = false
	# 	set_process(false)
