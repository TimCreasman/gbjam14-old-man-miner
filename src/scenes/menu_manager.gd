class_name MenuManager
extends Control

var menus = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit)
	%Start.pressed.connect(start)
	%Back.pressed.connect(back)
	for node in get_children():
		if node is Menu:
			menus.set(node.name, node)
	pass # Replace with function body.
	
func close_all_menus():
	for menu in menus.values():
		menu.visible=false

func open_menu_close_others(menu_name):
	close_all_menus()
	if menus.has(menu_name):
		menus.get(menu_name).visible=true
		

func play():
	print("pressed play")
	open_menu_close_others("NameMenu")
	
func quit():
	get_tree().quit()

func start():
	get_tree().change_scene_to_file("res://src/scenes/main.tscn")

func back():
	open_menu_close_others("MainMenu")

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
