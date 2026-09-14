extends Label
@export var node_component: Node

func _ready():
	if node_component.has_signal("changed"):
		node_component.connect("changed", update_label)

func update_label(amount):
	text = str(amount)
