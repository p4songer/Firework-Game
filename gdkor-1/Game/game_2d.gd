extends Node2D

@onready var firework: Node2D = $Firework

var is_crackle : bool = false
var active_color : Color

const STAR = preload("uid://c6fgnywnyo63w")

"""
COLORS KEY:
Red: Strontium or Lithium.
Orange: Calcium, or Strontium + Sodium.
Yellow: Sodium.
Green: Barium (often Barium Chloride).
Blue: Copper (often Copper Chloride).
Purple (Lavender/Violet): Strontium + Copper.
White: Magnesium, Aluminum,
Gold: Iron filings, Charcoal. 
Silver :  Titanium, Zirconium.

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
Palm : medium to small break with comets.

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

"""
NOTES FOR EFFECTS
crackle:
	ColorGradiant, Liketime = 2, Lifetime Random = 1
palm:
	might need to manually animate a certain number of stars
"""

func _ready() -> void:
	EventBus.launch_firework.connect(launch_firework)
	EventBus.star_finished_emitting.connect(_on_star_finished)


func launch_firework() -> void:
	var new_fire = STAR.instantiate()
	new_fire.global_position = firework.global_position
	new_fire.can_emit_signal = true
	self.add_child(new_fire)
	$Camera2D.target = new_fire
	new_fire.apply_central_impulse(Vector2.UP * 3500)
	new_fire.modulate = firework.break_data.main_color
	firework.toggle_sprite()

#
#func _on_canister_set_crackle() -> void:
	#is_crackle = not is_crackle
	#if is_crackle:

	#else:
		#firework.color_ramp = null
		#firework.lifetime = 1.0
		#firework.lifetime_randomness = 0
		#launch_firework()


func _on_star_finished() -> void:
	# stop moving camera
	$Camera2D.target = null
	
	firework.global_position = $Camera2D.global_position
	firework.self_modulate = active_color
	firework.display("break")
	#await firework.finished
	#
	#$Camera2D.target = $Launcher
