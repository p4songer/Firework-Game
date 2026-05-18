extends Control

@onready var scrollbar: VScrollBar = $Vbox/VScrollBar
@onready var color_grid: GridContainer = $Vbox/Colors/Grid
@onready var effect_grid: GridContainer = $Vbox/Effect/Grid
@onready var scroll_label: Label = $Vbox/VScrollBar/Label
@onready var mouse_timer: Timer = $MouseTimer

var active_color: String
var active_effect: int
var real_fuse_length: float = 2.75

var active_tween : Tween

const DEFAULT_ICON : GradientTexture2D = preload("uid://ubw2obtraius")
const DEFAULT_ICON_PRESSED : GradientTexture2D = preload("uid://bre17i2wf4p8u")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scrollbar.value_changed.connect(_on_scrollbar_value_changed)
	_update_grids()
	 

func _update_grids() -> void:
	var color_mixes: Dictionary = Global.get_mixes()
	for index in color_mixes.keys().size():
		var button = TextureButton.new()
		var mix = color_mixes.keys()[index]
		button.texture_normal = DEFAULT_ICON
		button.texture_pressed = DEFAULT_ICON_PRESSED
		button.self_modulate = color_mixes[mix]["color"]
		button.toggle_mode = true
		color_grid.add_child(button)
		button.pressed.connect(_on_color_button_pressed.bind(mix, index))
	var effects: Dictionary = Global.get_effects()
	for effect in effects.keys():
		var button = TextureButton.new()
		button.toggle_mode = true
		button.texture_normal = DEFAULT_ICON
		button.texture_pressed = DEFAULT_ICON_PRESSED
		effect_grid.add_child(button)


func _on_scrollbar_value_changed(value: float) -> void:
	real_fuse_length = abs(value - scrollbar.max_value) + scrollbar.step
	scroll_label.text = str(real_fuse_length) + " s"


func _on_color_button_pressed(mix_name: String, index: int) -> void:
	print("Color mix button pressed: " + mix_name, " INDEX: ", index)
	active_color = mix_name
	for idx in color_grid.get_child_count():
		if color_grid.get_child(idx).button_pressed:
			if idx == index:
				continue
			else:
				color_grid.get_child(idx).button_pressed = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: #or event is InputEventMouseButton:
		var menu_rect : Rect2 = $Vbox.get_global_rect()
		if not menu_rect.has_point(event.global_position):
			print("moved off")
			mouse_timer.start()
		else:
			print("moved on")
			mouse_timer.stop()


func activate(enabled: bool) -> void:
	if not enabled:
		if active_tween: active_tween.kill()
		active_tween = create_tween()
		active_tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
		await active_tween.finished
		self.queue_free()
	else:
		self.scale = Vector2.ZERO
		if active_tween: active_tween.kill()
		active_tween = create_tween()
		active_tween.tween_property(self, "scale", Vector2.ONE, 0.25)


func _on_mouse_timer_timeout() -> void:
	print("timed out")
	activate(false)


