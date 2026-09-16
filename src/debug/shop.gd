class_name OMM_Shop
extends Area2D
@export var shop_menu: Node
@export var player: OMM_Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	%Leave.pressed.connect(exit_shop)
	pass # Replace with function body.

func on_body_entered(body: Node2D) -> void:
	if body is OMM_Player:
		enter_shop()
		
func enter_shop():
		shop_menu.visible=  true
		player.shopping = true

func exit_shop():
	shop_menu.visible = false
	player.shopping = false
