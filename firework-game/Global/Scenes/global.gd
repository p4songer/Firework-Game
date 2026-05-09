extends Node

# var active_fireworks: Array = [] This should be safe to delete
# var is_whistle: bool = false This should be included in IngredientResource now.

## All NPC reviews collected across sessions. Each entry is an NPC_Resource instance representing a unique customer.
var review_array: Array[NPC_Resource] = []

## All unique NPC_Resource instances the player has encountered across sessions.
var customers_seen: Array[NPC_Resource] = []

## Appends unique NPC_Resource instances to customers_seen.
## Deduplication is performed by object reference identity.
## customers: The array of NPC_Resource instances to register.
func register_customers(customers: Array[NPC_Resource]) -> void:
	for customer: NPC_Resource in customers:
		if not customers_seen.has(customer):
			customers_seen.append(customer)

## Plays a one-shot SFX through the global audio player.
func play_sfx() -> void:
	$GlobalSFX.play()

#region Color Mix Registry

var _color_mix_registry: Dictionary = {}

## Registers a new color mix. Emits EventBus.color_changed to notify UI systems.
## mix_name: The identifier for this mix.
## cost: The purchase cost of the mix.
## color: The Color value associated with this mix.
func add_mix(mix_name: String, cost: float, color: Color) -> void:
	_color_mix_registry[mix_name] = {"cost": cost, "color": color}
	EventBus.color_changed.emit(color)

## Returns the data Dictionary for a mix, or an empty Dictionary if not found.
## The returned Dictionary contains keys "cost" (float) and "color" (Color).
## mix_name: The identifier of the mix to look up.
func get_mix(mix_name: String) -> Dictionary:
	return _color_mix_registry.get(mix_name, {})

## Removes a mix from the registry by name. Does nothing if the name is not found.
## mix_name: The identifier of the mix to remove.
func remove_mix(mix_name: String) -> void:
	_color_mix_registry.erase(mix_name)

## Returns true if a mix with the given name exists in the registry.
## mix_name: The identifier to check.
func mix_exists(mix_name: String) -> bool:
	return _color_mix_registry.has(mix_name)

## Returns all registered mix names as an Array of Strings.
func get_mixes() -> Dictionary:
	return _color_mix_registry

#endregion

#region Effect Registry
var _effect_registry: Dictionary = {}

## Registers a new effect. effect_string : String, is_dud : bool
func add_effect(effect_string: String, is_dud: bool) -> void:
	var suffix = "_dud" if is_dud else ""
	_effect_registry[effect_string + suffix] = {
		"effect": IngredientResource.key_to_effect(effect_string), 
		"cost": 0.0, "is_dud":is_dud
		}


func get_effect(effect_string: String) -> bool:
	return _effect_registry.get(effect_string, false)


func remove_effect(effect_type: IngredientResource.EFFECTS) -> void:
	_effect_registry.erase(effect_type)

## Returns true if an effect with the given type exists in the registry.
## effect_type: The EFFECTS enum value to check.
# func effect_exists(effect_type: IngredientResource.EFFECTS) -> bool:
# 	return _effect_registry.has(IngredientResource.key_to_effect(effect_type))


func get_effects() -> Dictionary:
	return _effect_registry
#endregion

#region Transition Functionality

enum TRANSITIONS {
	DEFAULT
}

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var _transition_dict: Dictionary = {
	TRANSITIONS.DEFAULT: "default"
}

@onready var anims: AnimationPlayer = $Transitions
var _next_scene: Node
var _previous_scene: Node

## Plays the end animation for the given transition prefix and finalizes the scene change.
## prefix: The transition name prefix matching a key in _transition_dict.
func get_end_anim(prefix: String) -> void:
	_change_scene()
	anims.play(prefix + "_end")
	await anims.animation_finished

## Begins a scene transition by instantiating the next scene and playing the opening animation.
## next_scene: The PackedScene to transition into.
## transition: The TRANSITIONS enum value selecting the animation style.
func start_transition(next_scene: PackedScene, transition: TRANSITIONS) -> void:
	_next_scene = next_scene.instantiate()
	_previous_scene = get_tree().get_current_scene()
	anims.play(_transition_dict[transition] + "_begin")

## Adds the next scene to the tree, removes the previous scene, and sets the current scene.
func _change_scene() -> void:
	var tree: SceneTree = get_tree()
	tree.get_root().add_child(_next_scene)
	_previous_scene.queue_free()
	tree.set_current_scene(_next_scene)

#endregion

func _ready() -> void:
	add_mix("CrimsonBurst", 10.0, Color8(220, 20, 60))
	add_mix("OceanBlue", 8.0, Color8(30, 144, 255))
	add_mix("Sunflare", 12.5, Color8(255, 180, 25))


func get_random_ingredient() -> IngredientResource:
	var effect = _effect_registry.keys().pick_random()
	var color = _color_mix_registry.keys().pick_random()
	var ingredient = IngredientResource.new()
	var is_dud = get_effect(effect)
	ingredient.effect = effect
	ingredient.is_dud = is_dud
	ingredient.ing_color = get_mix(color)["color"]
	return ingredient
