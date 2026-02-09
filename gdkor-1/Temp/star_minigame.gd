extends Node2D

@onready var parts: CPUParticles2D = $IngArea/Parts
@onready var instruction: Label = $Instructions/Vbox/CurrentInstruction

@export var current_build : String#:
	#set(new):
		#current_build = new
		#selected_array = build_dict[current_build]
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
	"default" : default_sequence,
	"crackle" : crackle_sequence,
	"brocade" : brocade_sequence,
	"palm": palm_sequence,
}
var selection_array : Array =[
	"Default Star", "Crackle Star", "Brocade Star", "Palm Star", 
]
var selection_index : int = 0
var active_array : Array
var active_element : String

var start_qte : bool = false

var is_mashing : bool = false
var mash_counter : int = 0

const TEST_ROTATE = preload("uid://qut0nlt30vsl")

func _ready() -> void:
	EventBus.spin_finished.connect(_on_spin_finished)
	EventBus.attempt_ingredient.connect(_on_attempt_ingredient)
	
	for b in $Instructions.get_children():
		if b is Button:
			b.pressed.connect(_on_selector_pressed.bind(b.name))
	instruction.text = selection_array[0]


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_mashing:
		mash_counter -= 1
		if mash_counter == 0:
			is_mashing = false
			_parse_build()
			$AnimationPlayer.play("RESET")


func _parse_build():
	if start_qte:
		$QteItem.show()
		$QteItem.start()
	parts.restart()
	parts.emitting = true
	if active_array.is_empty(): 
		instruction.text = "Done. Good job."
		await get_tree().create_timer(1.0).timeout
		EventBus.room_completed.emit()
		return
	active_element = active_array.pop_front()
	instruction.text = active_element.to_upper()
	if active_element == "mix":
		var new_spin = TEST_ROTATE.instantiate()
		$IngArea.add_child(new_spin)
	elif active_element == "press":
		activate_mash()
	elif active_element == "water":
		start_qte = true


func _on_spin_finished() -> void:
	$IngArea.get_child(-1).queue_free()
	_parse_build()


func _on_attempt_ingredient(ing_name : String) -> void:
	if ing_name == active_element:
		_parse_build()


func _on_selector_pressed(direction: String) -> void:
	selection_index = wrap(selection_index + int(direction), 0, selection_array.size())
	instruction.text = selection_array[selection_index]


func activate_mash() -> void:
	$AnimationPlayer.play("mash")
	is_mashing = true
	mash_counter = 10


func _on_craft_pressed() -> void:
	var choice = build_dict.keys()[selection_index]
	active_array = build_dict[choice]
	$"Instructions/-1".hide(); $"Instructions/1".hide(); $Instructions/Vbox/Craft.hide()
	_parse_build()


func _on_qte_item_dying(_which: Variant) -> void:
	$IngArea/Area2D/CollisionShape2D.disabled = true
	instruction.text = "You didn't finish in time. Try again."
