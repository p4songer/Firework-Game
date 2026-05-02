extends Node2D

var is_on_screen : bool = false
var componenets : Array[FireworkComponent] = []

func _ready() -> void:
	EventBus.room_changed.connect(_on_room_changed)


func _on_room_changed() -> void:
	if not is_on_screen: return
	var fire_res = FireworkResource.new()
	fire_res.sequence = componenets
	EventBus.firework_assembled.emit(fire_res)


func _on_gen_firework_pressed() -> void:
	var ingredient = Global.get_random_ingredient()
	var component = FireworkComponent.new()
	component.ingredient = ingredient
	component.fuse_length = randf_range(0.5, 2.5)
	componenets.append(component)



func _on_screen_exited() -> void:
	is_on_screen = false

func _on_screen_entered() -> void:
	is_on_screen = true
