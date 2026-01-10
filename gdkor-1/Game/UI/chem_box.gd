extends Control

@export var data : IngredientResource
signal pressed

func _ready() -> void:
	$TextureRect/Label.text = data.ing_name
	$TextureButton.self_modulate = data.ing_color


func _on_texture_button_pressed() -> void:
	pressed.emit()
