extends Node2D

@onready var grid: GridContainer = $UI/VBoxContainer/ScrollContainer/MarginContainer/GridContainer
@onready var cost_display: Label = $UI/VBoxContainer/Cost

var is_on_screen: bool = false

const COMPONENT: PackedScene = preload("uid://cngaxyt3toqcf")

# func _ready() -> void:
	# EventBus.room_changed.connect(_on_room_changed)

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

## Builds a FireworkResource from the player-defined connection chain and
## emits EventBus.firework_assembled. Does not perform inventory checks.
## TODO: Add Global inventory pre-check and consumption before emitting
## once the economy system is in place.
func finalize_assembly() -> void:
	var fire_res: FireworkResource = FireworkResource.new()
	fire_res.sequence = get_sequence_from_connections()
	for comp in fire_res.sequence:
		print_debug(comp.debug_name)
	EventBus.firework_assembled.emit(fire_res)

## Triggers finalize_assembly when a room_changed event fires, provided
## this scene is currently on screen. 

func _update_cost_display() -> void:
	var total_cost: float = 0.0
	var list = get_sequence_from_connections()

	for comp in list:
		total_cost += comp.component_cost
	
	cost_display.text = "Cost: $" + str(total_cost)


## Sets is_on_screen to false when the scene leaves the viewport.
func _on_screen_exited() -> void:
	is_on_screen = false

## Sets is_on_screen to true when the scene enters the viewport.
func _on_screen_entered() -> void:
	is_on_screen = true
