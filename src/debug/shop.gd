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
	StateManager.state_changed.connect(_on_state_changed)
	pass # Replace with function body.

func on_body_entered(body: Node2D) -> void:
	if body is OMM_Player:
		enter_shop()
		
func enter_shop():
	StateManager.change_state("shop")
	shop_menu.open()
	player.shopping = true

func exit_shop():
	StateManager.change_state("hub")
	shop_menu.close()
	player.shopping = false

func _on_state_changed(new_state, old_state) -> void:
	if new_state == "mine":
		visible=false
	if new_state == "hub":
		visible=true
