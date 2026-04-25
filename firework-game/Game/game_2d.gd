extends Node2D

var is_crackle : bool = false
var active_color : Color

#var whistle_arr : Array = [preload("uid://dd52q34uq2f1"), preload("uid://fb5jjrpt00tk")]
#var lift_arr : Array = [
	#preload("uid://dcc1xeh8vjkj0"), preload("uid://bg2rgv8001u0n")
#]
@onready var anim_arr : Array = ["lift", "break", "filler"]
var array_copy : Array

var item_tracker : int = 0

const STAR = preload("uid://c6fgnywnyo63w")
const LAUNCH_SCENE = preload("uid://dmlsjsr8rfh1")

"""
DUPLICATE COLORS ARE DIFFERENT SPRITES.

LIFTING CHARGE:
Any Effect or Color adds mine (cannot have hummer)
Adding phthalate will make whistle

magnesium / aluminum / magalium: reports and breaks (boom / crack / mix)

SHELL TYPE:
Hummer (Jumping Jacks), paper rolls instead of pellets
Fish (zigzaggy), made with cut up fuses in the shell
Strobe : Flashing filler. Mix of mag or al and barium

PATTERNS:
Brocade : large break, glittering trails
Crysanthenum : Any size break with basic color followed by crackle
Peony : Any size break with basic color
Palm : medium to small break with comets. Paper rolls

Order maybe:
customize pellets.
	color, effect, delay
customize number of pellets
	money required
customize break
	color
customize lift charge
	(for mines) color.
"""

func _ready() -> void:
	EventBus.part_finished.connect(_on_part_finished)
	EventBus.request_ingredient.connect(_on_request_ingredient)
	array_copy = anim_arr.duplicate()


func _on_part_finished() -> void:
	item_tracker += 1
	$UI.button_toggle()
	$WrapAnim.play(array_copy.pop_front())
	await $WrapAnim.animation_finished
	
	var tween = create_tween()
	tween.finished.connect(_trans_tween_finished)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property($Parts, "scroll_offset", Vector2(0, $Parts.scroll_offset.y + 1080), 0.5)


func _trans_tween_finished() -> void:
	if item_tracker == 3:
		Global.start_transition(LAUNCH_SCENE, Global.TRANSITIONS.DEFAULT)
		$UI.hide()
	else: $UI.button_toggle()


func _on_request_ingredient(part) -> void:
	await get_tree().create_timer(0.1).timeout
	part.update_display()
