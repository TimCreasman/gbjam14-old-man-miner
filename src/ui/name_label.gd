extends Label

var name_resource = preload("res://src/resources/name_resource.tres")

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

func _ready():
	seed(name_resource.get_player_name().hash())
	qualifiers.shuffle()
	text += name_resource.get_player_name() + " 'The " + qualifiers[0] + "'"
