extends CanvasLayer

@onready var ui_anim: AnimationPlayer = $UIAnim

@export var drawer_offset : Vector2 = Vector2(2080, -248)

var pausing : bool = false
var drawer_out : bool = false
var active_tween : Tween
var popup : PopupMenu
var is_whistle : bool = false

var counter : int = 0

const OPTIONS = preload("uid://dcdf81eayjyro")

signal pause_menu_changed

func _ready() -> void:
	EventBus.launch_firework.connect(_on_prepare_launch)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not pausing:
			pausing = true
			ui_anim.play("pause")
		else:
			pausing = false
			ui_anim.play_backwards("pause")
			await ui_anim.animation_finished

		pause_menu_changed.emit()
		get_tree().paused = pausing


func _on_button_pressed() -> void:
	Global.play_sfx()
	EventBus.part_finished.emit()
	counter += 1
	
	if counter == 3:
		$VBox/Button.pressed.disconnect(_on_button_pressed)
		$VBox/Button.pressed.connect(_launch_button_pressed)
		$VBox/Button.text = "Launch"
		
		EventBus.prepare_launch.emit()


func _launch_button_pressed() -> void:
	Global.play_sfx()
	EventBus.launch_firework.emit()


func _on_check_box_toggled(toggled_on: bool) -> void:
	Global.is_whistle = toggled_on


func _on_prepare_launch() -> void:
	counter = 0
	$VBox/Button.pressed.disconnect(_launch_button_pressed)
	$VBox/Button.pressed.connect(_reset_button_pressed)
	$VBox/Button.text = "Restart"


func _reset_button_pressed() -> void:
	get_tree().reload_current_scene()


func button_toggle() -> void:
	$VBox/Button.disabled = not $VBox/Button.disabled
