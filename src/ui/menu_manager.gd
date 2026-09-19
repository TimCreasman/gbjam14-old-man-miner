class_name MenuManager
extends Control

var menus = {}

func _ready():

	for child in get_children():
		if child is Menu:
			menus.set(child.name, child)
	#menus.get("MainMenu").buttons.get("Play").pressed.connect(play)
	#menus.get("MainMenu").buttons.get("Quit").pressed.connect(quit)
	#menus.get("NameMenu").buttons.get("Start").pressed.connect(start)
	#menus.get("NameMenu").buttons.get("Back").pressed.connect(back)
	
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit)
	%Start.pressed.connect(start)
	%Back.pressed.connect(back)
	open_menu_close_others("MainMenu")
	
func close_all_menus():
	for menu in menus.values():
		menu.close()

func open_menu_close_others(menu_name):
	close_all_menus()
	if menus.has(menu_name):
		menus.get(menu_name).open()

func play():
	print("pressed play")
	open_menu_close_others("NameMenu")
	
func quit():
	get_tree().quit()

func start():
	get_tree().change_scene_to_file("res://src/scenes/main.tscn")

func back():
	open_menu_close_others("MainMenu")
