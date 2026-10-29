## Hides all children unless this is a debug build
class_name DebugNode2D
extends Node2D
@export var always_hide = false

func _ready():
	hide()
	if OS.is_debug_build() && !always_hide:
		show()
