extends Node2D

@onready var grid: GridContainer = $UI/VBoxContainer/ScrollContainer/MarginContainer/GridContainer

var is_on_screen: bool = false
var componenets: Array[FireworkComponent] = []

const COMPONENT: PackedScene = preload("uid://cngaxyt3toqcf")

func _ready() -> void:
	EventBus.room_changed.connect(_on_room_changed)

## Appends a FireworkComponent to the assembly buffer.
## External systems should call this instead of mutating componenets directly.
## component: The FireworkComponent to add to the current assembly.
func add_component(component: FireworkComponent) -> void:
	componenets.append(component)

## Builds a FireworkResource from the current assembly buffer, emits
## EventBus.firework_assembled, and clears the buffer.
## Does not perform inventory checks.
## TODO: Add Global inventory pre-check and consumption before emitting
## once the economy system is in place.
func finalize_assembly() -> void:
	var fire_res: FireworkResource = FireworkResource.new()
	fire_res.sequence = componenets.duplicate()
	EventBus.firework_assembled.emit(fire_res)
	componenets.clear()

## Triggers finalize_assembly when a room_changed event fires, provided
## this scene is currently on screen. Preserves prior assembly behavior.
func _on_room_changed() -> void:
	if not is_on_screen:
		return
	finalize_assembly()


## Sets is_on_screen to false when the scene leaves the viewport.
func _on_screen_exited() -> void:
	is_on_screen = false

## Sets is_on_screen to true when the scene enters the viewport.
func _on_screen_entered() -> void:
	is_on_screen = true

func _on_add_pressed() -> void:
	var component = COMPONENT.instantiate()
	grid.add_child(component)
	if grid.get_child_count() == 1:
		component.is_first = true

## Debug helper. Generates a random ingredient via Global, wraps it in a
## FireworkComponent with a random fuse length, and adds it via add_component.
func _on_build_pressed() -> void:
	var ingredient: IngredientResource = Global.get_random_ingredient()
	var component: FireworkComponent = FireworkComponent.new()
	component.ingredient = ingredient
	component.fuse_length = randf_range(0.5, 2.5)
	add_component(component)
