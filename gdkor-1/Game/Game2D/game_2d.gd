extends Node2D

"""
COLORS KEY:
Red: Strontium or Lithium.
Orange: Calcium, or Strontium + Sodium.
Yellow: Sodium.
Green: Barium (often Barium Chloride).
Blue: Copper (often Copper Chloride).
Purple (Lavender/Violet): Strontium + Copper.
White/Silver: Magnesium, Aluminum, Titanium, Zirconium.
Gold: Iron filings, Charcoal. 
White : Magnesium
Silver : Titanium

EFFECTS KEY:
magnesium / aluminum / magalium: reports and breaks (boom / crack / mix)
xxx phthalate : Whistle / fuel
Zirconium : Waterfalls (medium lasting trails)
Shell type : Hummer (research this more)

Rockets, Flares, Mines, Willows, Waterfalls, Crackles, 
"""

func _ready() -> void:
	EventBus.color_changed.connect(_on_color_changed)


func _on_color_changed(new_color : Color) -> void:
	$CPUParticles2D.self_modulate = new_color
	$CPUParticles2D.emitting = true
