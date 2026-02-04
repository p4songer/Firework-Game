class_name NPC_Resource extends Resource

#TODO Notepad for customer preferences.
@export var npc_name : String
@export var fav_color : Color
@export var fav_effect : String

const _color_array : Array = [
	Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 0.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0), Color(0.7, 0.0, 0.7, 1.0), Color(1.0, 0.4, 0.0, 1.0)
]

const _effect_array : Array = [
	"crackle", "default", "brocade", "palm",
]
const _name_array : Array = [
	"Alice", "Benjamin", "Charlotte", "Daniel", "Evengy", " Frederick", "Guntah", "Henry",
	"Isabella", "Jamie", "Katherine", "Lucas", "Mooshroom", "Nathan", "Olivia", "Peter",
	"Quentin", "Rebecca", "Samuel", "Theodore", "Urbaiden", "Victoria", "William", "Xander",
	"Yasmin", "Zachary",
]
#TODO use these to make statements about what the firework looks like.
#const _color_statements : Dictionary = {
	#Color(1.0, 0.0, 0.0, 1.0): ["I like red fireworks"],
	#Color(0.0, 0.0, 1.0, 1.0): ["I like blue fireworks"],
	#
#}

func build_random() -> void:
	npc_name = _name_array.pick_random()
	fav_color = _color_array.pick_random()
	fav_effect = _effect_array.pick_random()
