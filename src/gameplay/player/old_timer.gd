extends Timer

@export var age_component: OMM_AgeComponent

func _ready():
	timeout.connect(age_component.increment_age)
