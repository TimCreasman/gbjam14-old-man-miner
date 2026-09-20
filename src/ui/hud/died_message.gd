extends Control

@export var age_component:OMM_AgeResource
@export var again_button: Button
@export var quit_button: Button
@export var death_label: Label

func _ready():
	age_component.died.connect(on_died)
	again_button.pressed.connect(restart)
	quit_button.pressed.connect(quit)

func on_died():
	again_button.grab_focus()
	death_label.text = age_component.get_death_reason()
	visible = true

func restart():
	visible = false
	StateManager.change_state(StateManager.STATE.HUB)
	SignalBus.restarted.emit()

func quit():
	get_tree().quit()
