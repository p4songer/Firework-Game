extends Control

@export var data : IngredientResource
@export var is_effect : bool
signal pressed

func _ready() -> void:
	$TextureRect/Label.text = data.ing_name
	if not is_effect:
		$TextureButton.self_modulate = data.ing_color
	else:
		$TextureButton.texture_normal = data.ing_sprite
		$TextureButton.texture_hover = null


func _on_texture_button_pressed() -> void:
	pressed.emit()
