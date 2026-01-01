extends Node

const FIREWORK_DICT : Dictionary = {
	"red": {"text": "the red kind", "color": Color(1.0, 0.0, 0.0, 1.0)},
	"blue": {"text": "the blue kind", "color": Color(0.0, 0.367, 1.0, 1.0)},
	"green": {"text": "the green kind", "color": Color(0.0, 0.715, 0.1, 1.0)},
}
var active_array : Array
var firework_index : int = 0

func _ready() -> void:
	for item in FIREWORK_DICT.keys():
		active_array.append(item)


func get_dict_item(request : String):
	match request:
		"text":
			return FIREWORK_DICT[active_array[firework_index]].text
		"color":
			return FIREWORK_DICT[active_array[firework_index]].color

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
