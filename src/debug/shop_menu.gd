class_name ShopMenu
extends Menu

@export var buyables: Array[OMM_ItemDefinition]
@export var buy_buttons: Container
@export var score_resource: OMM_ScoreResource
@export var buy_sound: AudioStreamPlayer2D
@export var not_enough_gold_sound: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for buyable in buyables:
		var button = Button.new()
		button.text = str(buyable.cost)
		button.icon = buyable.texture
		button.theme = load("res://UI.tres")
		button.pressed.connect(_on_buy_button_pressed.bind(buyable))
		buy_buttons.add_child(button)
	super()
	pass # Replace with function body.

func _on_buy_button_pressed(item_defintion: OMM_ItemDefinition):
	if item_defintion.cost <= score_resource._score and !item_defintion.is_unlocked:
		item_defintion.is_unlocked = true
		score_resource.increment_score(-item_defintion.cost)
		buy_sound.play()
		print("bought")
	else:
		not_enough_gold_sound.play()
		print("cant buy")
	pass

