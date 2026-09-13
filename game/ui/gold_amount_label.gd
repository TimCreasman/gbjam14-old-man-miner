extends Label
@export var score_component: OMM_ScoreComponent

func _ready():
	score_component.changed.connect(update_label)

func update_label(score_amount):
	text = str(score_amount)
