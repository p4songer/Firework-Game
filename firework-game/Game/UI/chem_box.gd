extends Control

@export var data : IngredientResource
@export var is_effect : bool
signal pressed

func _ready() -> void:
	$TextureRect/Label.text = data.ing_name
	print_debug(data.ing_name)
	if not is_effect:
		$TextureButton.self_modulate = data.ing_color
	else:
		$TextureButton.texture_normal = data.ing_sprite
		#$TextureButton.size = data.ing_sprite.get_size()
		$TextureButton.texture_hover = null


func _on_texture_button_pressed() -> void:
	pressed.emit()


func scale_button(new_size : Vector2) -> void:
	$TextureButton.scale = new_size
	var offset =  $TextureButton.texture_normal.get_size() / 2
	offset.y = 8
	$TextureButton.pivot_offset = offset


func _on_texture_button_mouse_entered() -> void:
	$TextureButton.modulate = Color("d9d9d9")


func _on_texture_button_mouse_exited() -> void:
	$TextureButton.modulate = Color("ffffffff")
