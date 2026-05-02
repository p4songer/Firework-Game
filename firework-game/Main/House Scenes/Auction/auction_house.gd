class_name AuctionHouse extends Node2D

## Listens to: none
## Emits: EventBus.qte_clicked(npc), EventBus.customers_cleared()
## Contract: Renders a static clickable customer lineup. Does not control any camera.
## NPC generation and lineup display are self-contained. HouseManager drives flow

#TODO Update Customer UI to live here.

@onready var lineup_container: Node2D = $LineupContainer

const QTE_ITEM: PackedScene = preload("uid://l2s6ioimdxc")

## Generates count randomized NPC_Resource instances, renders them as clickable lineup
## entries, and registers them with Global.customers_seen.
## count: The number of customers to generate and display.
func spawn_lineup(count: int) -> void:
	_clear_lineup()
	var npcs: Array[NPC_Resource] = []
	for i: int in count:
		var npc: NPC_Resource = NPC_Resource.new()
		npc.build_random()
		npcs.append(npc)
	Global.register_customers(npcs)
	for npc: NPC_Resource in npcs:
		var item: Node = QTE_ITEM.instantiate()
		item.npc_data = npc
		item.active = false
		item.scale = Vector2(0.75, 0.75)
		item.gui_input.connect(_on_item_gui_input.bind(npc, item))
		lineup_container.add_child(item)

## Removes all current lineup entries without emitting progression signals.
## Used for reset and reinitialization.
func _clear_lineup() -> void:
	for child: Node in lineup_container.get_children():
		child.queue_free()

## Handles gui_input on a lineup entry. Emits qte_clicked and removes the entry
## when the player clicks it.
## event: The input event received by the lineup item.
## npc: The NPC_Resource associated with this entry.
## item: The Node instance representing this entry in the lineup.
func _on_item_gui_input(event: InputEvent, npc: NPC_Resource, item: Node) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		EventBus.qte_clicked.emit(npc)
		item.queue_free()
		await get_tree().process_frame
		if lineup_container.get_child_count() == 0:
			EventBus.customers_cleared.emit()
