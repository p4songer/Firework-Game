extends CanvasLayer

@onready var ui_anim: AnimationPlayer = $UIAnim

@export var drawer_offset : Vector2 = Vector2(2080, -248)

var pausing : bool = false
var drawer_out : bool = false
var active_tween : Tween
var popup : PopupMenu

var counter : int = 0

const OPTIONS = preload("uid://dcdf81eayjyro")

signal pause_menu_changed

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
	EventBus.part_finished.emit()
	counter += 1
	
	if counter == 3:
		$Button.pressed.disconnect(_on_button_pressed)
		$Button.pressed.connect(_launch_button_pressed)


func _launch_button_pressed() -> void:
	EventBus.launch_firework.emit()
