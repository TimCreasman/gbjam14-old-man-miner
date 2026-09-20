class_name ShopMenu
extends Menu

@export var buyables: Array[OMM_ItemDefinition]
@export var buy_buttons: Container
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
	print(item_defintion.cost)
	pass

