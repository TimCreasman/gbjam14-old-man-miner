extends Control

func _ready():
	StateManager.state_changed.connect(_on_state_changed)

func _on_state_changed(state: StateManager.STATE, _old_state: StateManager.STATE):
	if state == StateManager.STATE.WIN:
		visible = true
	
