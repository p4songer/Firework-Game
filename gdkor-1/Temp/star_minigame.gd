extends Node2D

@export var current_build : String

var default_sequence : Array = [
	"dextrin", "water", "color", "mix", "oxidizer", "mix", "press"
]
var crackle_sequence : Array = [
	"dextrin", "water", "color", "oxidizer", "mix", "divider", "oxidizer",
	"mix", "divider", "oxidizer", "mix", "press"
]
var brocade_sequence : Array = [
	"dextrin", "water", "color", "charcoal", "oxidizer", "mix", "charcoal", "mix", "press"
]
var palm_sequence : Array = [
	"dextrin", "water", "color", "oxidizer", "mix", "wrap", "glue", "mix"
]

var build_dict : Dictionary = {
	"palm": palm_sequence,
	"brocade" : brocade_sequence,
	"crackle" : crackle_sequence,
	"default" : default_sequence
}
var selected_array : Array
var active_element : String

const TEST_ROTATE = preload("uid://qut0nlt30vsl")

func _ready() -> void:
	EventBus.spin_finished.connect(_on_spin_finished)
	EventBus.part_finished.connect(_on_part_finished)
	
	if current_build and current_build in build_dict.keys():
		selected_array = build_dict[current_build]
	else:
		selected_array = default_sequence
	
	_parse_build()


func _parse_build():
	active_element = selected_array.pop_front()
	$CurrentInstruction.text = active_element
	if active_element == "mix":
		var new_spin = TEST_ROTATE.instantiate()
		$IngArea.add_child(new_spin)


func _on_spin_finished() -> void:
	$IngArea.get_child(-1).queue_free()
	_parse_build()


func _on_part_finished() -> void:
	_parse_build()
