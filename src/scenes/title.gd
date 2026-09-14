extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit)
	pass # Replace with function body.

func play():
	get_tree().change_scene_to_file("res://game/scene/main.tscn")

func quit():
	get_tree().quit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
