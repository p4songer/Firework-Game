extends Node2D

var default_sequence : Array = [
	"dextrin", "water / start", "color", "mix", "oxidizer", "mix", "press"
]
var crackle_sequence : Array = [
	"dextrin", "water / start", "color", "oxidizer", "mix", "divider", "oxidizer",
	"mix", "divider", "oxidizer", "mix", "press"
]
var brocade_sequence : Array = [
	"dextrin", "water/start", "color", "charcoal", "oxidizer", "mix", "charcoal", "mix", "press"
]
var palm_sequence : Array = [
	"dextrin", "water/start", "color", "oxidizer", "mix", "wrap", "glue", "mix"
]
func _ready() -> void:
	pass
