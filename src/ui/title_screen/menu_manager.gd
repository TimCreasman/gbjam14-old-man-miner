class_name MenuManager
extends Control

var name_resource = preload("res://src/resources/atom_resources/string_resources/name_resource.tres")
var next_scene = preload("res://src/scenes/main.tscn")

var menus = {}

func _ready():

	for child in get_children():
		if child is Menu:
			menus.set(child.name, child)
	
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
	open_menu_close_others("NameMenu")
	
func quit():
	get_tree().quit()

func start():
	name_resource.set_value(%NameLineEdit.text)
	get_tree().change_scene_to_packed(next_scene)

func back():
	open_menu_close_others("MainMenu")
