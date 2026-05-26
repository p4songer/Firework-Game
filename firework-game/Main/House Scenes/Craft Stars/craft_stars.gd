extends Node2D

## Listens to: EventBus.new_grain
## Emits: EventBus.craft_stars_completed(final_color: Color)
## Contract: This scene manages grain collection and pitcher UI locally.
## It emits its computed final color when crafting completes and does not
## reference HouseManager or any external scene directly.

#TODO Make black not ugly

@onready var grain_holder: Node2D = $GrainHolder
@onready var jar_area: Area2D = $Sprite2D/Area2D

@export var pitcher_array: Array[Array]

var final_color: Color

func _ready() -> void:
	EventBus.new_grain.connect(_on_new_grain)
	for i: int in pitcher_array.size():
		$Vbox/Hbox.get_child(i).set_data(pitcher_array[i])


func _process(_delta: float) -> void:
	if grain_holder.get_child_count() > 765:
		grain_holder.get_child(0).queue_free()
	var new_color: Color = Color(0.0, 0.0, 0.0, 1.0)
	for g: Node2D in jar_area.get_overlapping_bodies():
		@warning_ignore("narrowing_conversion")
		new_color.r8 += g.modulate.r
		@warning_ignore("narrowing_conversion")
		new_color.b8 += g.modulate.b
		@warning_ignore("narrowing_conversion")
		new_color.g8 += g.modulate.g
	$Chem.modulate = new_color


## Adds a grain node to the grain holder.
## new_grain: The grain Node2D instance to add.
func add_grain(new_grain: Node2D) -> void:
	#TODO Make it so that adding grains is restricted to inventory.
	grain_holder.add_child(new_grain)


## Enables or disables this scene's Camera2D.
## active: If true, enables the camera.
# func toggle_camera(active: bool) -> void:
# 	$Camera2D.enabled = active


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("pitcher"):
		await get_tree().create_timer(0.1).timeout


## Receives a new grain from EventBus and positions it relative to this scene.
## grain: The grain Node2D instance emitted by a pitcher.
func _on_new_grain(grain: Node2D) -> void:
	grain.global_position -= self.global_position
	grain_holder.add_child(grain)


## Computes and returns the color cost based on grain count. Resets grain count.
func finalize_color_cost() -> float:
	var cost: float = Economy.get_color_cost(grain_holder.get_child_count())
	for g in grain_holder.get_children(): g.queue_free()
	return cost


## Finalizes crafting, stores the computed color, and emits completion signals.
func _on_button_pressed() -> void:
	final_color = $Chem.modulate
	var color_cost: float = finalize_color_cost()
	EventBus.craft_stars_completed.emit(final_color, color_cost)
	#TODO Reset the scene here.
