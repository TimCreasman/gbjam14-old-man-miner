extends CanvasLayer

@export var name_resource: OMM_StringResource
@export var score_resource: OMM_ValueResource
@export var death_count_resource: OMM_ValueResource

@export var name_label: Label
@export var gold_label: Label
@export var death_label: Label


func _ready():
	name_label.text = name_resource.get_value()
	gold_label.text = "$" + str(score_resource.get_total())
	death_label.text = str(death_count_resource.get_total())


func _process(_delta: float):
	if Input.is_action_just_pressed("jump"):
		MusicManager.stop_all_songs()
		get_tree().change_scene_to_file("res://src/scenes/title.tscn")
