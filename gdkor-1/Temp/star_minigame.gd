extends Node2D

@onready var parts: CPUParticles2D = $IngArea/Parts

@export var current_build : String:
	set(new):
		current_build = new
		selected_array = build_dict[current_build]
@export var active : bool = false

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

var is_mashing : bool = false
var mash_counter : int = 0

const TEST_ROTATE = preload("uid://qut0nlt30vsl")

func _ready() -> void:
	EventBus.spin_finished.connect(_on_spin_finished)
	EventBus.attempt_ingredient.connect(_on_attempt_ingredient)
	#
	#if current_build and current_build in build_dict.keys():
		#selected_array = build_dict[current_build]
	#else:
		#selected_array = default_sequence
	#
	#_parse_build()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_mashing:
		mash_counter -= 1
		if mash_counter < 0:
			_parse_build()
			is_mashing = false
			$AnimationPlayer.play("RESET")

func _parse_build():
	parts.restart()
	parts.emitting = true
	if selected_array.is_empty(): 
		$CurrentInstruction.text = "Done. Good job."
		return
	active_element = selected_array.pop_front()
	$CurrentInstruction.text = active_element
	if active_element == "mix":
		var new_spin = TEST_ROTATE.instantiate()
		$IngArea.add_child(new_spin)
	elif active_element == "press":
		activate_mash()


func _on_spin_finished() -> void:
	$IngArea.get_child(-1).queue_free()
	_parse_build()


func _on_attempt_ingredient(ing_name : String) -> void:
	if ing_name == active_element:
		_parse_build()


func activate_mash() -> void:
	$AnimationPlayer.play("mash")
	is_mashing = true
	mash_counter = 10
