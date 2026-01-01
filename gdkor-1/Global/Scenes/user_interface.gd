extends CanvasLayer

@onready var pause_anim: AnimationPlayer = $PauseAnim

@export var dimension_2d: bool

var pausing : bool = false
var popup : PopupMenu

const OPTIONS = preload("uid://dcdf81eayjyro")

signal pause_menu_changed

func _ready() -> void:
	$HBox/Previous.pressed.connect(_on_color_pressed.bind(-1))
	$HBox/Next.pressed.connect(_on_color_pressed.bind(1))
	update_text()


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
	update_text()


func _on_menu_button_pressed() -> void:
	if not popup:
		popup = $HBox/MenuButton.get_popup()
		popup.index_pressed.connect(_pop_menu_selected)
		for item in Global.active_array:
			popup.add_item(item)


func _pop_menu_selected(index : int) -> void:
	Global.firework_index = index
	update_text()


func update_text() -> void:
	# TODO Make this a global issue, not a local issue
	$HBox/MenuButton.text = Global.get_dict_item("text")
	EventBus.color_changed.emit(Global.get_dict_item("color"))
