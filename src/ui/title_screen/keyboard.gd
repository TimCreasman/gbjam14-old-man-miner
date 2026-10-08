class_name OMM_Keyboard
extends VBoxContainer

var buttons = {}
var entry_box: LineEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in find_children("*"):
		if child is Button:
			buttons.set(child.text, child)
			child.pressed.connect(_on_button_pressed.bind(child))
		if child is LineEdit:
			entry_box = child
	
func _on_button_pressed(button: Button) -> void:
	if button.text == "<":
		entry_box.text = entry_box.text.left(-1)
	else:
		entry_box.text += button.text
	pass
# Called when the node enters the scene tree for the first time.
