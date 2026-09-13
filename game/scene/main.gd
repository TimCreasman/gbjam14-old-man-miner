extends SubViewportContainer

@export var pause_action = "pause"
# Called when the node enters the scene tree for the first time.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(pause_action):
		toggle_pause()

func toggle_pause():
	var tree = get_tree()
	tree.paused = !tree.paused
	%PauseMenu.visible = tree.paused
	
func _ready():
	
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
