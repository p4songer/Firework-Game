extends Node2D

@onready var grid: GridContainer = $UI/VBoxContainer/ScrollContainer/MarginContainer/GridContainer
@onready var cost_display: Label = $UI/VBoxContainer/Cost

var is_on_screen: bool = false

const COMPONENT: PackedScene = preload("uid://cngaxyt3toqcf")

## Instantiates a new firework_piece, assigns it a fresh FireworkComponent,
## adds it to the grid, and marks it as the first piece if it is the only one.
func _on_add_pressed() -> void:
    var piece: Node = COMPONENT.instantiate()
    var comp: FireworkComponent = FireworkComponent.new()
    comp.debug_name = piece.name + str(grid.get_child_count())
    piece.component = comp
    grid.add_child(piece)
    piece.update_cost.connect(_update_cost_display)
    if grid.get_child_count() == 1:
        piece.is_first = true

## Walks the player-defined connection chain starting from the piece marked
## is_first and returns an ordered Array of FireworkComponent instances.
## Returns an empty array if no first piece is found or the chain is empty.
func get_sequence_from_connections() -> Array[FireworkComponent]:
    var sequence: Array[FireworkComponent] = []
    var first_piece: Node = null
    for child: Node in grid.get_children():
        if child is Control and (child as Control).is_first:
            first_piece = child
            break
    if first_piece == null:
        push_warning("Assembly: no first piece found. Sequence will be empty.")
        return sequence
    var current: Node = first_piece
    var visited: Dictionary = {}
    while current != null and not visited.has(current):
        visited[current] = true
        var comp: FireworkComponent = current.get_component()
        if comp != null:
            sequence.append(comp)
        else:
            push_warning("Assembly: piece has no component assigned. Skipping.")
        current = current.connected_firework
    return sequence

## Counts ingredient ing_name occurrences across the sequence and returns a
## bundle dictionary mapping material keys to required quantities.
func _compute_bundle_from_sequence(sequence: Array[FireworkComponent]) -> Dictionary:
    var bundle: Dictionary = {}
    for comp: FireworkComponent in sequence:
        if comp.ingredient == null:
            continue
        var key: String = comp.ingredient.ing_name
        if key.is_empty():
            continue
        bundle[key] = bundle.get(key, 0) + 1
    return bundle

## Gates assembly against Inventory, consumes the required bundle, and emits
## firework_assembled. Aborts silently if materials are insufficient.
func finalize_assembly() -> void:
    var sequence: Array[FireworkComponent] = get_sequence_from_connections()
    if sequence.is_empty():
        push_warning("Assembly: sequence is empty. Aborting.")
        return
    var bundle: Dictionary = _compute_bundle_from_sequence(sequence)
    if Inventory.calculate_max_craftable(bundle) == 0:
        push_warning("Assembly: insufficient materials to assemble.")
        return
    for item: String in bundle.keys():
        Inventory.remove_item(item, bundle[item])
    var fire_res: FireworkResource = FireworkResource.new()
    fire_res.sequence = sequence
    for comp in fire_res.sequence:
        print_debug(comp.debug_name)
    EventBus.firework_assembled.emit(fire_res)  

func _update_cost_display() -> void:
    var total_cost: float = 0.0
    var list: Array[FireworkComponent] = get_sequence_from_connections()
    for comp in list:
        total_cost += comp.component_cost
    cost_display.text = "Cost: $" + str(total_cost)


## Sets is_on_screen to false when the scene leaves the viewport.
func _on_screen_exited() -> void:
    is_on_screen = false

    ## Sets is_on_screen to true when the scene enters the viewport.
func _on_screen_entered() -> void:
    is_on_screen = true
