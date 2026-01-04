extends Node

#const FIREWORK_DICT : Dictionary = {
	#"red_1": {"text": "Strontium", "color": Color(1.0, 0.0, 0.0, 1.0)},
	#"red_2": {"text": "Lithium", "color": Color(0.88, 0.059, 0.0, 1.0)},
	#"blue": {"text": "Copper", "color": Color(0.0, 0.367, 1.0, 1.0)},
	#"green": {"text": "Barium", "color": Color(0.0, 0.715, 0.1, 1.0)},
	#"orange_1": {"text": "Calcium", "color": Color(1.0, 0.467, 0.0, 1.0)},
	#"orange_2": {"text": "Strontium + Sodium", "color": Color(1.0, 0.3, 0.0, 1.0)},
	#"yellow": {"text": "Sodium", "color": Color(0.95, 1.0, 0.0, 1.0)},
	#"purple": {"text": "Strontium + Copper", "color": Color(0.833, 0.0, 1.0, 1.0)},
	#"white_1": {"text": "Aluminum", "color": Color(1.0, 1.0, 0.9, 1.0)},
	#"white_2": {"text": "Magnesium", "color": Color(1.0, 0.9, 0.9, 1.0)},
	#"gold": {"text": "Iron + Charcoal", "color": Color(1.0, 0.816, 0.21, 1.0)},
	#"silver": {"text": "Zirconium", "color": Color(0.71, 0.71, 0.71, 1.0)},
#}
const FIRE_RESOURCES : Array = [
	preload("uid://chs5icc2rx3w7"), preload("uid://bxkbhs08v5r6r"), preload("uid://7jjmoa7qa28y"),
	preload("uid://dgdvg4kucekux"), preload("uid://cqkcjrv1kywv0"), preload("uid://yh4cpjejnkb2"),
	preload("uid://dic88j7pevp7"), preload("uid://chpyavxb1yn04"), preload("uid://wmuthliqpv3m"),
	preload("uid://dfop8tbeeruhd"), preload("uid://iw02skqqsv1e"), preload("uid://dp7b46nggluhg"),
]
#var color_array : Array
#var color_index : int = 0

#func _ready() -> void:
	#for item in FIREWORK_DICT.keys():
		#color_array.append(item)


#func get_dict_array(request: String) -> Array:
	#var temp_arr = []
	#for item in color_array:
		#match request:
			#"text":
				#temp_arr.append(FIREWORK_DICT[item].text)
	#return temp_arr
#
#
#func get_dict_item(request : String):
	#match request:
		#"text":
			#return FIREWORK_DICT[color_array[color_index]].text
		#"color":
			#return FIREWORK_DICT[color_array[color_index]].color

#region Transition Functionality
enum TRANSITIONS {
	DEFAULT
}
var RNG = RandomNumberGenerator.new()

var _transition_dict : Dictionary = {
	TRANSITIONS.DEFAULT: "default"
}

@onready var anims: AnimationPlayer = $Transitions
var _next_scene : Node
var _previous_scene : Node

func get_end_anim(prefix: String) -> void:
	_change_scene()
	anims.play(prefix + "_end")
	await anims.animation_finished


func start_transition(next_scene: PackedScene, transition: TRANSITIONS) -> void:
	_next_scene = next_scene.instantiate()
	_previous_scene = get_tree().get_current_scene()
	anims.play(_transition_dict[transition] + "_begin")


func _change_scene() -> void:
	var tree = get_tree()
	tree.get_root().add_child(_next_scene)
	tree.get_root().remove_child(_previous_scene)
	tree.set_current_scene(_next_scene)
#endregion
