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

var _color_dict: Dictionary = {
    "red": "strontium", 
    "green": "barium",
    "blue": "copper",
}

var _active_grains: Array[Node2D]

func _ready() -> void:
    EventBus.new_grain.connect(_on_new_grain)
    for i: int in pitcher_array.size():
        $Vbox/Hbox.get_child(i).set_data(pitcher_array[i])


func _on_area_2d_area_exited(area: Area2D) -> void:
    if area.is_in_group("pitcher"):
        await get_tree().create_timer(0.1).timeout

## Infers a color key string from a grain's modulate by dominant channel.
func _map_modulate_to_color_key(color: Color) -> String:
    if color.r >= color.g and color.r >= color.b:
        return "red"
    elif color.g >= color.r and color.g >= color.b:
        return "green"
    return "blue"

## Receives a new grain from EventBus. Gates spawn against Inventory and
## consumes one unit of the mapped material before adding the grain to the scene.
func _on_new_grain(grain: Node2D) -> void:
    var color_key: String = _map_modulate_to_color_key(grain.modulate)
    var item: String = _color_dict.get(color_key, "")
    if item.is_empty() or Inventory.calculate_max_craftable({item: 1}) == 0:
        grain.queue_free()
        return
    Inventory.remove_item(item, 1)
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
