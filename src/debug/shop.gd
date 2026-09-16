class_name OMM_Shop
extends Area2D
@export var shop_menu: Menu
@export var player: OMM_Player
@export var music_manager: MusicManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_menu.close()
	body_entered.connect(on_body_entered)
	%Leave.pressed.connect(exit_shop)
	pass # Replace with function body.

func on_body_entered(body: Node2D) -> void:
	if body is OMM_Player:
		enter_shop()
		
func enter_shop():
		music_manager.switch_to_song("ShopTheme")
		shop_menu.open()
		player.shopping = true

func exit_shop():
	music_manager.switch_to_song("HubTheme")
	shop_menu.close()
	player.shopping = false
