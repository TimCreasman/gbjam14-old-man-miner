extends Timer

@export var age_component: OMM_AgeResource

func _ready():
	timeout.connect(age_component.increment_age)
	
