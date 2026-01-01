extends CanvasLayer

@onready var pause_anim: AnimationPlayer = $PauseAnim

@export var dimension_2d: bool

var pausing : bool = false

const OPTIONS = preload("uid://dcdf81eayjyro")

signal pause_menu_changed

func _ready() -> void:
	$HBox/Previous.pressed.connect(_on_color_pressed.bind(-1))
	$HBox/Next.pressed.connect(_on_color_pressed.bind(1))
	$HBox/ColorLabel.text = Global.active_array[0]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not pausing:
			pausing = true
			pause_anim.play("pause")
			if not dimension_2d:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			pausing = false
			pause_anim.play_backwards("pause")
			await pause_anim.animation_finished
			if not dimension_2d:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

		pause_menu_changed.emit()
		get_tree().paused = pausing


func _on_color_pressed(direction : int) -> void:
	Global.firework_index = wrap(Global.firework_index + direction, 0, len(Global.active_array))
	$HBox/ColorLabel.text = Global.active_array[Global.firework_index]
