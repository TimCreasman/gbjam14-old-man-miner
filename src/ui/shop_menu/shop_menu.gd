class_name ShopMenu
extends Menu

@export var buyables: Array[OMM_Buyable]
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

func _on_buy_button_pressed(buyable: OMM_Buyable):
	var purchase_made = false
	if buyable.cost <= score_resource._score:
		if buyable is OMM_ItemDefinition and !buyable.is_unlocked:
			buyable.is_unlocked = true
			score_resource.increment_score(-buyable.cost)
			purchase_made = true
		if buyable is OMM_UpgradeDefintion:
			match buyable.UPGRADE_TYPES:
				OMM_UpgradeDefintion.UPGRADE_TYPES.SPEED:
					purchase_made = true
				OMM_UpgradeDefintion.UPGRADE_TYPES.MINE:
					purchase_made = true
				OMM_UpgradeDefintion.UPGRADE_TYPES.JUMP:
					purchase_made = true
	if purchase_made:
		buy_sound.play()
	else:
		not_enough_gold_sound.play()
		print("cant buy")
