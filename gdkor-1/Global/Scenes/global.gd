extends Node

# TODO Make a dict to hold color mixes. Name of a mix, and the cost, with the associated color.
# TODO Make customer reviews that can populate after launch.
# Extendable so that users don't have to mix a new color every time.

"""
Stirring moves a potion along a path. Path collects levels. Once reached, billows are used to add the destinations's effect. Then UI for name, ingredient, save recipie etc. Ingredients change the direction of the path.
Mortar and Pestle optionally doubles ingredients ground. Also extends path. Potions can be created through ingredient book.
Rooms are navigated with WASD.
To sell, you place potion on a scale. You have the option to haggle. Costs reputation. Reputation affects the type (good or bad) of customers in shop each day. Haggle either increases or decreases price sold. Haggling brings up a sliding arrow minigame. You can only haggle once.
Customers don't leave. There's a set amount each day, and day ends when all customers are finished. Bedroom room with bed to end day. Extra decoration.
Additional features: Skill tree (things like speed up garden, more harvest) Alchemy Machine (broken thing you need to repair)

Maybe sourcing ingredients / components?
Sodium / Potassium Benzoate (whistle) - Domestic
Aluminum - Canada
Barium - India, China, Domestic
Copper - Chile (U), Domestic (U), China (R)



Story beats about life milestones. Fireworks don't celebrate overall holidays, but individuals as a community event.
Fireworks are a special rare thing, making it something for deep personal events. As such, the firework crafters are artisans,
working closely with the clientelle to fit their exact situation.
"""

const FIRE_RESOURCES : Array = [
	preload("uid://chs5icc2rx3w7"), preload("uid://bxkbhs08v5r6r"), preload("uid://7jjmoa7qa28y"),
	preload("uid://dgdvg4kucekux"), preload("uid://cqkcjrv1kywv0"), preload("uid://yh4cpjejnkb2"),
	preload("uid://dic88j7pevp7"), preload("uid://chpyavxb1yn04"), preload("uid://wmuthliqpv3m"),
	preload("uid://dfop8tbeeruhd"), preload("uid://iw02skqqsv1e"), preload("uid://dp7b46nggluhg"),
]
const EFFECT_RESOURCES : Array = [
	preload("uid://betka3xy08pd8"), preload("uid://ba8pex888vrj8"), preload("uid://dqn1ei0yfg4xk"),
	preload("uid://p8bqtov2wh0x"),
]
var active_fireworks : Array = []
var is_whistle : bool = false
var review_array : Array[NPC_Resource]

func play_sfx() -> void:
	$GlobalSFX.play()

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

#func _ready() -> void:
	#push_error("MUSIC IS NOT AUTOPLAY")
	

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
	_previous_scene.queue_free()
	#tree.get_root().remove_child(_previous_scene)
	tree.set_current_scene(_next_scene)
#endregion
