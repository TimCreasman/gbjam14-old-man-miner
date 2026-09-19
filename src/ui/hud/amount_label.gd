extends Label
@export var resource : Resource

func _ready():
	if resource && resource.has_signal("changed"):
		resource.connect("changed", update_label)

func update_label(amount):
	text = str(amount)
