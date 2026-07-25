extends Node2D

#TODO Acetone is a cheap alternative to water, but has a faster timer.
#TODO This should be the workstation for every firework part. Not just stars.

@onready var ing_area: Sprite2D = $IngArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var col_shape: CollisionShape2D = $IngArea/Area2D/CollisionShape2D
@onready var qte_item: Control = $QteItem
@onready var parts: CPUParticles2D = $IngArea/Parts
@onready var instruction: Label = $Instructions/Vbox/CurrentInstruction
@onready var back_button: Button = $"Instructions/Vbox/Buttons/-1"
@onready var next_button: Button = $"Instructions/Vbox/Buttons/1"
@onready var craft_button: Button = $Instructions/Vbox/Buttons/Craft
@onready var q_slider: HSlider = $Instructions/Vbox/Sliders/Hbox/QSlider
@onready var q_min_label : Label = $Instructions/Vbox/Sliders/Hbox/QMin
@onready var q_max_label : Label = $Instructions/Vbox/Sliders/Hbox/QMax
@onready var q_label: Label = $Instructions/Vbox/Sliders/Quantity

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
	"dextrin", "water", "color", "oxidizer", "mix", "palm wrap", "glue", "mix", "mix"
]

var build_dict : Dictionary = {
	"FLOWER" : {"sequence": default_sequence, "display": "Default Star"},
	"CRACKLE" : {"sequence": crackle_sequence, "display": "Crackle Star"},
	"BROCADE" : {"sequence": brocade_sequence, "display": "Brocade Star"},
	"PALM" : {"sequence": palm_sequence, "display": "Palm Star"},
}

var selection_index : int = 0
var active_array : Array
var active_element : String

var start_qte : bool = false
var is_mashing : bool = false
var mash_counter : int = 0

var is_game_over : bool = false

var max_craftable : int = 0
var selected_quantity : int = 1

const TEST_ROTATE = preload("uid://c0we4sqqu2wm6")

signal start_game

func _ready() -> void:
	EventBus.spin_finished.connect(_on_spin_finished)
	EventBus.attempt_ingredient.connect(_on_attempt_ingredient)
	back_button.pressed.connect(_on_selector_pressed.bind(back_button.name))
	next_button.pressed.connect(_on_selector_pressed.bind(next_button.name))
	q_slider.value_changed.connect(_on_quantity_changed)

	instruction.text = build_dict.values()[0]["display"]
	
	for eff in IngredientResource.EFFECTS:
		test_dictionary(eff)
	
	for item in build_dict.keys():
		for step in build_dict[item]["sequence"]:
			match step:
				"color", "mix", "press", "water":
					continue
				_:
					var recipe : Dictionary = build_dict[item].get("recipe", {})
					var value = recipe.get(step, 0) + 1
					recipe[step] = value
					build_dict[item]["recipe"] = recipe
	
	_update_quantity()


func _process(_delta: float) -> void:
	if is_game_over: return

	if Input.is_action_just_pressed("ui_accept") and is_mashing:
		mash_counter -= 1
		if mash_counter == 0:
			is_mashing = false
			_parse_build()
			animation_player.play("RESET")


func _parse_build() -> void:
	if start_qte:
		qte_item.show()
		qte_item.start()
		start_qte = false
	parts.restart()
	parts.emitting = true
	if active_array.is_empty():
		instruction.text = "Done. Good job."
		is_game_over = true
		_consume_active_recipe()
		var effect_cost: float = build_dict.values()[selection_index]["sequence"].size() * 1.25
		EventBus.star_minigame_completed.emit(build_dict.keys()[selection_index], true, effect_cost)
		await get_tree().create_timer(1.0).timeout
		_reset_scene()
		return
	active_element = active_array.pop_front()
	instruction.text = active_element.to_upper()
	if active_element == "mix":
		var new_spin = TEST_ROTATE.instantiate()
		ing_area.add_child(new_spin)
	elif active_element == "press":
		activate_mash()
	elif active_element == "water":
		start_qte = true

## Deducts all recipe materials for the cu rrently selected effect from Inventory.
## Called on both success and failure paths.
func _consume_active_recipe() -> void:
	var recipe: Dictionary = build_dict.values()[selection_index].get("recipe", {})
	for item: String in recipe.keys():
		var amount: int = recipe[item] * selected_quantity
		if amount > 0:
			Inventory.remove_item(item, amount)


func _on_spin_finished() -> void:
	if is_game_over: return
	ing_area.get_child(-1).queue_free()
	_parse_build()


func _on_attempt_ingredient(ing_name: String) -> void:
	if ing_name == active_element:
		_parse_build()


func _on_selector_pressed(direction: String) -> void:
	selection_index = wrap(selection_index + int(direction), 0, build_dict.size())
	instruction.text = build_dict.values()[selection_index]["display"]
	_update_quantity()


func activate_mash() -> void:
	animation_player.play("mash")
	is_mashing = true
	mash_counter = 10

## Gates minigame start against Inventory. If the selected recipe cannot be
## satisfied by at least one unit, the craft is blocked silently.
func _on_craft_pressed() -> void:
	var choice: String = build_dict.keys()[selection_index]
	var recipe: Dictionary = build_dict[choice].get("recipe", {})
	if selected_quantity > Inventory.calculate_max_craftable(recipe) or selected_quantity <= 0:
		push_warning("Attempted to craft more than available stockpile allows.")
		return
	

	active_array = build_dict[choice]["sequence"].duplicate()
	back_button.hide(); next_button.hide(); craft_button.hide()
	_parse_build()
	start_game.emit()


func _on_qte_item_dying(_which: Variant) -> void:
	if is_game_over: return

	is_game_over = true
	animation_player.play("RESET")
	col_shape.disabled = true
	await animation_player.animation_finished
	instruction.text = "You didn't finish in time. Dud firework."

	_consume_active_recipe()
	var effect_cost: float = build_dict.values()[selection_index]["sequence"].size() * 1.25
	EventBus.star_minigame_completed.emit(build_dict.keys()[selection_index], false, effect_cost)

	await get_tree().create_timer(1.0).timeout
	_reset_scene() 

func _reset_scene() -> void:
	is_game_over = false
	start_qte = false
	is_mashing = false
	mash_counter = 0
	active_array = []
	active_element = ""

	for child in ing_area.get_children():
		if child.is_in_group("spin_game"):
			child.queue_free()

	col_shape.disabled = false
	qte_item.hide()
	back_button.show()
	next_button.show()
	craft_button.show()
	instruction.text = build_dict.values()[selection_index]["display"]


func _on_quantity_changed(value: float) -> void:
	selected_quantity = int(value)
	q_label.text = "Quantity: " + str(selected_quantity)


func _update_quantity() -> void:
	var recipe: Dictionary = build_dict.values()[selection_index].get("recipe", {})
	max_craftable = Inventory.calculate_max_craftable(recipe)
	q_slider.max_value = max_craftable

	q_min_label.text = "1"
	q_max_label.text = str(max_craftable)


func test_dictionary(effect) -> void:
	if effect in build_dict:
		return
	else:  
		push_warning("Invalid effect enum value for build dict: " + str(effect))
