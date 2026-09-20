class_name OMM_ShopMenuLayer
extends CanvasLayer

@export var menu: Menu

func _ready():
	menu.close()

func open():
	menu.open()

func close():
	menu.close()

func get_leave_button() -> Button:
	return %Leave
	# %Leave.pressed.connect(exit_shop)
