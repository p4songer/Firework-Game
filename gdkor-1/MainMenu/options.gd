extends Control

var play_sound : bool = false
var sfx_changed : bool = false

const RNG_SFX : Array = [
	preload("uid://chtil3nern5rp"),  preload("uid://cjag0mx15yque"), preload("uid://bhn67hnt0je65"),
	preload("uid://bg2rgv8001u0n"),  preload("uid://dd52q34uq2f1")
]

func _ready() -> void:
	sfx_changed = false


func _on_menu_pressed() -> void:
	Global.play_sfx()
	Global.start_transition(load("res://MainMenu/main_menu.tscn"), Global.TRANSITIONS.DEFAULT)
	if get_tree().paused: get_tree().paused = false


func _on_sfx_value_changed(_value: float) -> void:
	sfx_changed = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if sfx_changed:
			var choice = randi_range(0, len(RNG_SFX) - 1)
			$SFX.stream = RNG_SFX[choice]
			$SFX.play()
			play_sound = false
			sfx_changed = false
