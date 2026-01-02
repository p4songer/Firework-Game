extends Node2D

@onready var firework: CPUParticles2D = $Firework

var is_crackle : bool = false

const CRACKLE_EFFECT = preload("uid://erboc5klvgf")

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
	EventBus.color_changed.connect(_on_color_changed)


func _on_color_changed(new_color : Color) -> void:
	launch_firework(new_color)


func launch_firework(selected_color: Color = Color(0.0, 0.0, 0.0, 0.0)) -> void:
	firework.self_modulate = selected_color
	firework.emitting = true


func _on_canister_set_crackle() -> void:
	is_crackle = not is_crackle
	if is_crackle:
		firework.color_ramp = CRACKLE_EFFECT
		firework.lifetime = 2.0
		firework.lifetime_randomness = 1
		launch_firework()
	else:
		firework.color_ramp = null
		firework.lifetime = 1.0
		firework.lifetime_randomness = 0
		launch_firework()
