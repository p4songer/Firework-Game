extends Control

@onready var scrollbar: VScrollBar = $Vbox/VScrollBar
@onready var color_grid: GridContainer = $Vbox/Colors/Grid
@onready var effect_grid: GridContainer = $Vbox/Effect/Grid
@onready var scroll_label: Label = $Vbox/VScrollBar/Label
@onready var mouse_timer: Timer = $MouseTimer

var active_color: String
var active_effect: String # Changed to String to match Dictionary keys
var real_fuse_length: float = 2.75

var active_tween : Tween
var mouse_hover : bool = false
var is_active : bool = false

const DEFAULT_ICON : GradientTexture2D = preload("uid://ubw2obtraius")
const DEFAULT_ICON_PRESSED : GradientTexture2D = preload("uid://bre17i2wf4p8u")

signal menu_closed(active_color: String, active_effect: String, real_fuse_length: float)

func _ready() -> void:
	scrollbar.value_changed.connect(_on_scrollbar_value_changed)
	_update_grids()

func _update_grids() -> void:
	# --- Color Grid Setup ---
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

	# --- Effect Grid Setup ---
	var effects: Dictionary = Global.get_effects()
	for index in effects.keys().size():
		var button = TextureButton.new()
		var effect_name = effects.keys()[index]
		button.toggle_mode = true
		button.texture_normal = DEFAULT_ICON
		button.texture_pressed = DEFAULT_ICON_PRESSED
		
		# Optional: If you want to color-tint or texture your effect icons based 
		# on global configuration parameters later, you'd do it here.
		
		effect_grid.add_child(button)
		# Bind both the effect identifier key and its grid index
		button.pressed.connect(_on_effect_button_pressed.bind(effect_name, index))


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


	# --- New Effect Button Radio-Group Logic ---
func _on_effect_button_pressed(effect_name: String, index: int) -> void:
	print("Effect button pressed: " + effect_name, " INDEX: ", index)
	active_effect = effect_name

	# Clear alternative options to make selections mutually exclusive
	for idx in effect_grid.get_child_count():
		if effect_grid.get_child(idx).button_pressed:
			if idx == index:
				continue
			else:
				effect_grid.get_child(idx).button_pressed = false


func _input(event: InputEvent) -> void:
	if not is_active: return

	if event is InputEventMouseMotion:
		if mouse_hover:
			mouse_timer.stop()
		else:
			mouse_timer.start()


func activate(enabled: bool) -> void:
	if not enabled:
		if active_tween: active_tween.kill()
		active_tween = create_tween()
		active_tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
		await active_tween.finished
		
		# --- Save / Emit Configuration on Destruction ---
		_dispatch_selected_data()
		is_active = false
	else:
		self.scale = Vector2.ZERO
		if active_tween: active_tween.kill()
		active_tween = create_tween()
		active_tween.tween_property(self, "scale", Vector2.ONE, 0.25)
		is_active = true 


func _on_mouse_timer_timeout() -> void:
	activate(false)


	# Packaging choices into the global pipeline
func _dispatch_selected_data() -> void:
	# print("Saving Data: Color=", active_color, " Effect=", active_effect, " Fuse=", real_fuse_length)
	menu_closed.emit(active_color, active_effect, real_fuse_length)


func _on_area_2d_mouse_entered() -> void:
	mouse_hover = true


func _on_area_2d_mouse_exited() -> void:
	mouse_hover = false
