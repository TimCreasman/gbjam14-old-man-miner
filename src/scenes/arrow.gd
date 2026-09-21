extends Sprite2D

@export var old_state: StateManager.STATE = 1
@export var new_state: StateManager.STATE = 2

func _ready():
	StateManager.state_changed.connect(_on_state_changed)
	hide()

func _on_state_changed(_new_state: StateManager.STATE, _old_state: StateManager.STATE):
	if _new_state == new_state && _old_state == old_state:
		show()
	else:
		hide()
	
