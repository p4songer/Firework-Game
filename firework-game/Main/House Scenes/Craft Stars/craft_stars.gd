extends Node2D

## Listens to: EventBus.new_grain
## Emits: EventBus.craft_stars_completed(final_color: Color)
## Contract: This scene manages grain collection and pitcher UI locally.
## It emits its computed final color when crafting completes and does not
## reference HouseManager or any external scene directly.

#TODO Make black not ugly
@onready var chem: Sprite2D = $Chem
@onready var grain_holder: Node2D = $GrainHolder
@onready var jar_area: Area2D = $Sprite2D/Area2D

@export var pitcher_array: Array[Array]

var final_color: Color
var _color_dict : Dictionary ={
	"red": "strontium",
	"green": "barium",
	"blue": "copper",
}

var _color_available: Dictionary = {
	"red": 0,
	"green": 0,
	"blue": 0,
}

var _active_grains: Array[Node2D]
var _grain_counter: int = 0

func _ready() -> void:
	EventBus.new_grain.connect(_on_new_grain)
	for i: int in pitcher_array.size():
		$Vbox/Hbox.get_child(i).set_data(pitcher_array[i])
	for key in _color_available.keys():
		_color_available[key] = Inventory.get_count(_color_dict[key])


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("pitcher"):
		await get_tree().create_timer(0.1).timeout


## Receives a new grain from EventBus and positions it relative to this scene.
## grain: The grain Node2D instance emitted by a pitcher.
func _on_new_grain(grain: Node2D) -> void:
	#TODO Make it so that adding grains is restricted to inventory.
	grain.global_position -= self.global_position
	grain_holder.add_child(grain)
	_active_grains.append(grain)


func _on_jar_body_entered(body: Node2D) -> void:
	if not body.is_in_group("grain"): return

	body.set_entered()
	if grain_holder.get_child_count() > 765:
		var choice = _active_grains.pop_front()
		if not choice: return # Safety to prevent frame perfect errors.
		final_color.r8 -= int(choice.modulate.r)
		final_color.g8 -= int(choice.modulate.g)
		final_color.b8 -= int(choice.modulate.b)
		choice.queue_free()

	final_color.r8 += int(body.modulate.r)
	final_color.g8 += int(body.modulate.g)
	final_color.b8 += int(body.modulate.b)
	chem.modulate = final_color


## Finalizes crafting, stores the computed color, and emits completion signals.
func _on_button_pressed() -> void:
	final_color = chem.modulate
	var color_cost: float = _active_grains.size() * 0.1
	EventBus.craft_stars_completed.emit(final_color, color_cost)
	_reset_scene()


func _reset_scene() -> void:
	_active_grains.clear()

	final_color = Color(0, 0, 0)
	chem.modulate = final_color
