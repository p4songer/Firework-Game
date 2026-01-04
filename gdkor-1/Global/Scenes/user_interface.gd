extends CanvasLayer

@onready var ui_anim: AnimationPlayer = $UIAnim

var pausing : bool = false
var drawer_out : bool = false
var active_tween : Tween
var popup : PopupMenu

const OPTIONS = preload("uid://dcdf81eayjyro")

signal pause_menu_changed

func _ready() -> void:
	for item : IngredientResource in Global.FIRE_RESOURCES:
		var new_button = Button.new()
		new_button.icon = item.ing_sprite
		new_button.text = item.ing_name
		new_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
		$Drawer/GridContainer.add_child(new_button)


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
	EventBus.launch_firework.emit()


func _on_texture_button_pressed() -> void:
	if active_tween: active_tween.kill()
	active_tween = create_tween()
	active_tween.set_ease(Tween.EASE_IN_OUT)
	active_tween.set_trans(Tween.TRANS_BACK)
	var final = Vector2(2048, 0) if drawer_out else Vector2(2048 - ($Drawer.size.x + 25), 0)
	active_tween.tween_property($Drawer, "position", final, 0.5)
	
	drawer_out = not drawer_out
