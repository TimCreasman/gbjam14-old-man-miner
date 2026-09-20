class_name NameLabel
extends Label

var name_resource = preload("res://src/resources/name_resource.tres")
@export var generation_resource: OMM_GenerationResource
var qualifiers = [
	"Brave",
	"Stout",
	"Cool",
	"Fearless",
	"Conqueror",
	"Sad",
	"Enraged",
	"Bubbly",
	"Grotesque",
	"Gruesome",
	"Great",
	"Derpy One",
]

static var rng = RandomNumberGenerator.new()


func update_label():
	if generation_resource.generation == 1:
		text = "Go forth and mine, " + name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " the 1st of your line"
	if generation_resource.generation == 2:
		text = "Go forth and mine, " +  name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " the 2st of your line"
	if generation_resource.generation == 3:
		text = "Go forth and mine, " +  name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " the 3th of your line"
	if generation_resource.generation == 4:
		text = "Go forth and mine, " +  name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " the 4rd of your line"
	if generation_resource.generation == 5:
		text = "Go forth and mine, " + name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " the 5st of your line"
	if generation_resource.generation == 6:
		text = "Go forth and mine, " +  name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " the 2^2+2st of your line"
	if generation_resource.generation >= 7:
		text = "Go forth and mine, " + name_resource.get_player_name() + " 'The " + qualifiers[0] + "'" + "\n" + " There's no more easter eggs past 6 it was a tight deadline ok"

func _on_generation_changed(generation):
	update_label()
	pass

func _ready():
	generation_resource.changed.connect(_on_generation_changed)
	seed(name_resource.get_player_name().hash())
	qualifiers.shuffle()
	update_label()
