extends Control

@export var speed = 0.05
@export var max_scale = Vector2(1.1, 1.1)
@export var min_scale = Vector2.ONE

var viewport_limits : Vector2

var tween_dict: Dictionary 

const OPTIONS_SCENE = preload("uid://dcdf81eayjyro")
const GAME_2D = preload("uid://dydw0o4rwye4u")
const HOUSE_MANAGER = preload("uid://cj73xl2uujryc")

func _ready() -> void:
	for button in $MarginContainer/VBoxContainer.get_children():
		button.mouse_entered.connect(_on_button_hovered.bind(button))
		button.mouse_exited.connect(_on_button_unhovered.bind(button))


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var cont = $MarginContainer
		cont.position.x = clamp(cont.position.x - event.relative.x * speed, -75, 75)
		cont.position.y = clamp(cont.position.y - event.relative.y * speed, -75, 75)


func _on_start_game_pressed() -> void:
	Global.play_sfx()
	Global.start_transition(HOUSE_MANAGER, Global.TRANSITIONS.DEFAULT)


func _on_options_pressed() -> void:
	Global.play_sfx()
	Global.start_transition(OPTIONS_SCENE, Global.TRANSITIONS.DEFAULT)


func _on_quit_pressed() -> void:
	Global.play_sfx()
	get_tree().quit()


func _on_button_hovered(button):
	if button in tween_dict.keys():
		tween_dict[button].kill()
	var tween = create_tween()
	tween.tween_property(button, "scale", max_scale, 0.2)
	
	tween_dict[button] = tween
	tween.finished.connect(_remove_tween.bind(button))


func _on_button_unhovered(button):
	if button in tween_dict.keys():
		tween_dict[button].kill()
	var tween = create_tween()
	tween.tween_property(button, "scale", min_scale, 0.2)
	
	tween_dict[button] = tween
	tween.finished.connect(_remove_tween.bind(button))


func _remove_tween(index):
	tween_dict.erase(index)
