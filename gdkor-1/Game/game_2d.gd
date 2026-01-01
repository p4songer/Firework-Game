extends Node2D

@onready var firework: CPUParticles2D = $Firework

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

func _ready() -> void:
	EventBus.color_changed.connect(_on_color_changed)


func _on_color_changed(new_color : Color) -> void:
	launch_firework(new_color)


func launch_firework(selected_color: Color) -> void:
	firework.self_modulate = selected_color
	firework.emitting = true
