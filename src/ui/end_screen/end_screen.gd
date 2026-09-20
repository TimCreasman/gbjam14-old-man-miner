extends CanvasLayer

@export var name_resource: OMM_NameResource
@export var score_resource: OMM_ScoreResource
@export var age_resource: OMM_AgeResource

@export var name_label: Label
@export var gold_label: Label
@export var death_label: Label

func _ready():
	name_label.text = name_resource.get_player_name()
	gold_label.text = "$" + str(score_resource.get_total_score())
	death_label.text = str(age_resource.get_death_count())

func _process(delta: float):
	if Input.is_action_just_pressed("jump"):
		MusicManager.stop_all_songs()
		get_tree().change_scene_to_file("res://src/scenes/title.tscn")
		pass
