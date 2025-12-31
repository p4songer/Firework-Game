extends CanvasLayer

@onready var pause_anim: AnimationPlayer = $PauseAnim

@export var dimension_2d: bool

var pausing : bool = false

const OPTIONS = preload("uid://dcdf81eayjyro")

signal pause_menu_changed

func _ready() -> void:
	EventBus.target_clicked.connect(_on_target_clicked)


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


func _on_target_clicked(points : int) -> void:
	$Points.text = str(int($Points.text) + points)
