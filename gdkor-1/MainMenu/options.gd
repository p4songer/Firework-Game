extends Control

var play_sound : bool = false
var sfx_changed : bool = false

func _ready() -> void:
	sfx_changed = false


func _on_menu_pressed() -> void:
	Global.start_transition(load("res://MainMenu/main_menu.tscn"), Global.TRANSITIONS.DEFAULT)
	if get_tree().paused: get_tree().paused = false


func _on_sfx_value_changed(_value: float) -> void:
	sfx_changed = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if sfx_changed:
			$SFX.play()
			play_sound = false
			sfx_changed = false
