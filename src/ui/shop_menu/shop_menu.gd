class_name ShopMenu
extends Menu

@export var upgrades: Array[OMM_UpgradeDefintion] = []
@export var items: Array[OMM_ItemDefinition] = []

@export var buy_upgrade_buttons: Container
@export var item_upgrade_buttons: Container

@export var score_resource: OMM_ScoreResource
@export var buy_sound: AudioStreamPlayer2D
@export var not_enough_gold_sound: AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for buyable in upgrades:
		buy_upgrade_buttons.add_child(create_button(buyable))

	for buyable in items:
		item_upgrade_buttons.add_child(create_button(buyable))
	super()

# func _on_upgrade_finished(button: Button):
# 	button.disabled = true

func create_button(buyable: OMM_Buyable) -> Button:
	var button = Button.new()
	button.text = str(buyable.cost)
	button.icon = buyable.texture
	button.pressed.connect(_on_buy_button_pressed.bind(buyable, button))

	# if buyable is OMM_UpgradeDefintion:
	# 	buyable.upgrade_resource.upgrade_finished.connect(_on_upgrade_finished.bind(button))
	
	if buyable:
		pass
	return button

func _on_buy_button_pressed(buyable: OMM_Buyable, button: Button):
	var purchase_made = false
	if buyable.cost <= score_resource._score:

		if buyable is OMM_ItemDefinition and !buyable.is_unlocked:
			buyable.is_unlocked = true
			button.text="sold"
			score_resource.decrement_score(buyable.cost)
			purchase_made = true

		if buyable is OMM_UpgradeDefintion:
			score_resource.decrement_score(buyable.cost)
			buyable.upgrade_resource.upgrade_stat()
			purchase_made = true
			
	if purchase_made:
		buy_sound.play()
		
	else:
		not_enough_gold_sound.play()
