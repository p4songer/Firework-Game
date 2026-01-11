extends Node2D

@onready var mine: CPUParticles2D = $Mine
@onready var fire_break: CPUParticles2D = $Break
@onready var effect: CPUParticles2D = $Effect

@export var destination = Vector2.UP * 5000

var is_crackle : bool = false
var active_color : Color

var whistle_arr : Array = [preload("uid://dd52q34uq2f1"), preload("uid://fb5jjrpt00tk")]
var lift_arr : Array = [
	preload("uid://dcc1xeh8vjkj0"), preload("uid://bg2rgv8001u0n")
]

const STAR = preload("uid://c6fgnywnyo63w")

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
	EventBus.launch_firework.connect(launch_firework)
	EventBus.star_finished_emitting.connect(_on_star_finished)
	EventBus.part_finished.connect(_on_part_finished)


func launch_firework() -> void:
	$LaunchTimer.start()
	fire_break.global_position = $Parts/LaunchScene.get_launch_pos()
	var ingredient = Global.active_fireworks.pop_front()
	mine.display(ingredient)
	
	var tween = create_tween()
	tween.tween_property(fire_break, "global_position", destination, 1.35)
	tween.finished.connect(_on_star_finished)
	effect.global_position = destination
	
	fire_break.modulate = ingredient.ing_color 
	fire_break.is_trail = true
	
	if $UI.is_whistle:
		whistle_arr.shuffle()
		$Whistle.stream = whistle_arr[0]
		$Whistle.play()
	else:
		lift_arr.shuffle()
		$Whistle.stream = lift_arr[0]
		$Whistle.play()


func _on_star_finished() -> void:
	# stop moving camera
	#$Camera2D.target = null
	#
	#firework.global_position = $Camera2D.global_position
	fire_break.display(Global.active_fireworks.pop_front())
	$DelayTimer.start()
	$Camera2D.target = effect


func _on_delay_timer_timeout() -> void:
	var rand_x = randf_range(fire_break.global_position.x - 500, fire_break.global_position.x + 500)
	var rand_y = randf_range(fire_break.global_position.y - 750, fire_break.global_position.y + 750)
	effect.global_position = Vector2(rand_x, rand_y)
	effect.display(Global.active_fireworks.pop_front())
	
	#$Camera2D.target = firework


func _on_launch_timer_timeout() -> void:
	$Camera2D.target = fire_break


func _on_part_finished() -> void:
	#$Parts.scroll_offset.y += 1080
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property($Parts, "scroll_offset", Vector2(0, $Parts.scroll_offset.y + 1080), 0.5)
