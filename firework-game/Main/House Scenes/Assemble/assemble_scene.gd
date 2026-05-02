extends Node2D


func _on_gen_firework_pressed() -> void:
	var ingredient = Global.get_random_ingredient()
	print(ingredient.effect, ingredient.ing_color)
