extends Node2D

#FIXME acetone is cheap alternative to water, but faster timer.
#FIXME Water should be a slower timer.
#TODO This should also be the station for making tubes and cakes and such.

@onready var parts: CPUParticles2D = $IngArea/Parts
@onready var instruction: Label = $Instructions/Vbox/CurrentInstruction

@export var current_build : String
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
	"dextrin", "water", "color", "oxidizer", "mix", "wrap", "glue", "mix", "mix"
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

var is_game_over : bool = false

const TEST_ROTATE = preload("uid://c0we4sqqu2wm6")

signal start_game

func _ready() -> void:
	EventBus.spin_finished.connect(_on_spin_finished)
	EventBus.attempt_ingredient.connect(_on_attempt_ingredient)
	
	for b in $Instructions.get_children():
		if b is Button:
			b.pressed.connect(_on_selector_pressed.bind(b.name))
	instruction.text = selection_array[0]


func _process(_delta: float) -> void:
	if is_game_over: return
	
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
		is_game_over = true
		EventBus.star_minigame_completed.emit(selection_index, true)
		await get_tree().create_timer(0.75).timeout
		# FIXME Reset game here.
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
	if is_game_over: return
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
	start_game.emit()


func _on_qte_item_dying(_which: Variant) -> void:
	if is_game_over: return

	is_game_over = true
	$AnimationPlayer.play("RESET")
	$IngArea/Area2D/CollisionShape2D.disabled = true
	await $AnimationPlayer.animation_finished
	instruction.text = "You didn't finish in time. Dud firework."
	
	Global.review_array[-1].dud_firework = true
	await get_tree().create_timer(1.0).timeout
	EventBus.star_minigame_completed.emit(selection_index, false)
	#FIXME Reset game here.
