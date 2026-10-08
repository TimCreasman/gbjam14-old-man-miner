class_name Menu
extends Control
var is_open = false;
var buttons = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in find_children("*"):
		if child is Button:
			buttons.set(child.name, child)

func open() -> void:
	visible = true
	is_open = true
	if buttons.size() > 0: 
		buttons.values()[0].grab_focus()
	
func close() -> void:
	visible = false
	is_open = false
