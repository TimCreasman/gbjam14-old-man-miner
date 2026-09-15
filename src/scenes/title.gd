extends Control

@export var main_menu: Control
@export var name_menu: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit)
	%Start.pressed.connect(start)
	%Back.pressed.connect(back)
	pass # Replace with function body.

func play():
	main_menu.visible=false
	name_menu.visible=true
	
func quit():
	get_tree().quit()

func start():
	get_tree().change_scene_to_file("res://game/scene/main.tscn")

func back():
	main_menu.visible=true
	name_menu.visible=false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
