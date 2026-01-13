extends Node

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
var _previous_scene : Node:
	set(new):
		_previous_scene = new
		print("Set previous to ", new)

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
