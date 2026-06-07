extends Node


## Storage for fireworks when launch scene is loaded.
var fireworks_to_launch : Array[FireworkResource] = []

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
