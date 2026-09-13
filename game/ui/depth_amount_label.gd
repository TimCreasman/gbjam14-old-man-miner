extends Label
@export var depth_component: OMM_DepthComponent

func _ready():
	depth_component.changed.connect(update_label)

func update_label(depth_amount):
	text = str(depth_amount)
