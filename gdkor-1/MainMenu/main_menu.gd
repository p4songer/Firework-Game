extends Control

@export var speed = 0.05
@export var max_scale = Vector2(1.1, 1.1)
@export var min_scale = Vector2.ONE

var viewport_limits : Vector2

var tween_dict: Dictionary 

const OPTIONS_SCENE = preload("uid://dcdf81eayjyro")
const GAME_2D = preload("uid://dydw0o4rwye4u")
const GAME_3D = preload("uid://b6xlgqe0twxs6")

var temp_array = [preload("uid://dcdf81eayjyro"), preload("uid://dydw0o4rwye4u"), preload("uid://b6xlgqe0twxs6")]

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
	# enable new buttons
	$MarginContainer/VBoxContainer/HBoxContainer.show()
	for button in $"MarginContainer/VBoxContainer/HBoxContainer".get_children():
		button.mouse_entered.connect(_on_button_hovered.bind(button))
		button.mouse_exited.connect(_on_button_unhovered.bind(button))
	
	#disable old buttons
	$MarginContainer/VBoxContainer/Start.hide()
	$MarginContainer/VBoxContainer/Start.disconnect("mouse_entered", _on_button_hovered)
	$MarginContainer/VBoxContainer/Start.disconnect("mouse_exited", _on_button_unhovered)


func _on_options_pressed() -> void:
	Global.start_transition(OPTIONS_SCENE, Global.TRANSITIONS.DEFAULT)


func _on_quit_pressed() -> void:
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


func _on_2d_pressed() -> void:
	Global.start_transition(GAME_2D, Global.TRANSITIONS.DEFAULT)


func _on_3d_pressed() -> void:
	Global.start_transition(GAME_3D, Global.TRANSITIONS.DEFAULT)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var new_scene = temp_array.pick_random().instantiate()
		self.add_child(new_scene)
