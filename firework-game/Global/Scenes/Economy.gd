extends Node

var _money : float = 0.0
var _color_inventory : Dictionary = {}
var _effect_inventory : Dictionary = {}

func get_money() -> float:
	return _money


func set_money(amount: float) -> void:
	_money = amount 


func add_color(color_name: String, data: Dictionary) -> void:
	_color_inventory[color_name] = data


func add_effect(effect_name: String, data: Dictionary) -> void:
	_effect_inventory[effect_name] = data


func effect_by_name(effect_name: String) -> Dictionary:
	if not _effect_inventory.has(effect_name):
		push_error("Effect not found in inventory: " + effect_name)
		return {}
	return _effect_inventory.get(effect_name)


func color_by_name(color_name: String) -> Dictionary:
	if not _color_inventory.has(color_name):
		push_error("Color not found in inventory: " + color_name)
		return {}
	return _color_inventory.get(color_name)


func get_all_colors() -> Dictionary:
	return _color_inventory


func get_all_effects() -> Dictionary:
	return _effect_inventory
