class_name NameLabel
extends Label

var name_resource = preload("res://src/resources/atom_resources/string_resources/name_resource.tres")
var qualifiers = [
	"Brave",
	"Broken",
	"Stout",
	"Cool",
	"Curious",
	"Fearless",
	"Conqueror",
	"Sad",
	"Enraged",
	"Bubbly",
	"Grotesque",
	"Gruff",
	"Clumsy",
	"Inept",
	"Dirty",
	"Sassy",
	"Erratic",
	"Gruesome",
	"Whacky",
	"Yodeling",
	"Sleepy",
	"Knucklehead",
	"Conniving",
	"Daft",
	"Exuberant",
	"Hefty",
	"Zesty",
	"Vivacious",
	"Great",
	"Derpy One",
]

static var rng = RandomNumberGenerator.new()


func update_label():
	text = "Go forth and mine, \n" + name_resource.get_value() + " 'The " + qualifiers[0] + "'" + "\n May your lineage \n reach the golden \n plains at the bottom" 

func _ready():
	seed(name_resource.get_value().hash())
	qualifiers.shuffle()
	update_label()
