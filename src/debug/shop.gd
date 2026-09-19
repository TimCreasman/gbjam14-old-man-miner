class_name OMM_Shop
extends RigidBody2D
@export var shop_menu: OMM_ShopMenuLayer
@export var player: OMM_Player
@export var music_manager: MusicManager

@export_category("Internal Components")
@export var sprite: Sprite2D
@export var area_2d: Area2D

var closed = false

func _ready() -> void:
	shop_menu.close()
	area_2d.body_entered.connect(on_body_entered)
	shop_menu.get_leave_button().pressed.connect(exit_shop)
	StateManager.state_changed.connect(_on_state_changed)

func on_body_entered(body: Node2D) -> void:
	if closed:
		return

	if body is OMM_Player:
		enter_shop()
		
func enter_shop():
	StateManager.change_state(StateManager.STATE.SHOP)
	shop_menu.open()
	player.process_mode = Node.PROCESS_MODE_DISABLED

func exit_shop():
	StateManager.change_state(StateManager.STATE.HUB)
	shop_menu.close()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	close()

func close():
	area_2d.body_entered.disconnect(on_body_entered)
	sprite.frame = 1

func _on_state_changed(new_state, _old_state) -> void:
	if new_state == StateManager.STATE.MINE:
		close()
	# if new_state == StateManager.STATE.HUB:
	# 	sprite.frame = 0
