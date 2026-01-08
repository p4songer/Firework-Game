extends Node2D

@onready var mine: CPUParticles2D = $Mine
@onready var fire_break: CPUParticles2D = $Break
@onready var effect: CPUParticles2D = $Effect

@export var destination = Vector2.UP * 5000

var is_crackle : bool = false
var active_color : Color

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


func launch_firework() -> void:
	#var new_fire = STAR.instantiate()
	#new_fire.global_position = firework.global_position
	#new_fire.can_emit_signal = true
	#self.add_child(new_fire)
	#new_fire.apply_central_impulse(Vector2.UP * 3500)
	$LaunchTimer.start()
	var ingredient = Global.active_fireworks.pop_front()
	mine.display(ingredient)
	
	var tween = create_tween()
	tween.tween_property(fire_break, "global_position", destination, 2.0)
	tween.finished.connect(_on_star_finished)
	effect.global_position = destination
	fire_break.modulate = ingredient.ing_color #Global.active_fireworks[0].ing_color


func _on_star_finished() -> void:
	# stop moving camera
	#$Camera2D.target = null
	#
	#firework.global_position = $Camera2D.global_position
	fire_break.display(Global.active_fireworks.pop_front())
	$DelayTimer.start()
	$Camera2D.target = effect


func _on_delay_timer_timeout() -> void:
	var rand_x = randf_range(fire_break.global_position.x - 100, fire_break.global_position.x + 100)
	var rand_y = randf_range(fire_break.global_position.y - 250, fire_break.global_position.y + 250)
	effect.global_position = Vector2(rand_x, rand_y)
	effect.display(Global.active_fireworks.pop_front())
	
	#$Camera2D.target = firework


func _on_launch_timer_timeout() -> void:
	$Camera2D.target = fire_break
