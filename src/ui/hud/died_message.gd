extends Control

@export var age_component:OMM_AgeResource
@export var again_button: Button
@export var quit_button: Button
@export var death_label: Label

func _ready():
	age_component.died.connect(on_died)
	again_button.pressed.connect(restart)
	quit_button.pressed.connect(quit)

func on_died(death_reason: OMM_AgeResource.DEATH_REASON):
	again_button.grab_focus()
	death_label.text = OMM_AgeResource.DEATH_REASON_READABLE[death_reason]
	visible = true

func restart():
	visible = false
	StateManager.change_state(StateManager.STATE.HUB)
	SignalBus.restarted.emit()

func quit():
	get_tree().change_scene_to_file("res://src/ui/end_screen/end_screen.tscn")
