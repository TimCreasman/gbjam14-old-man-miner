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

func _on_generation_changed(generation):
	pass

func _ready():
	generation_resource.changed.connect(_on_generation_changed)
	seed(name_resource.get_player_name().hash())
	qualifiers.shuffle()
	text += name_resource.get_player_name() + " 'The " + qualifiers[0] + "'"
