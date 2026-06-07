extends Node2D

@onready var lineup_container: Node2D = $LineupContainer

@export var active : bool = false

var bid_array : Array

const QTE_ITEM = preload("uid://l2s6ioimdxc")
const LAUNCH = preload("uid://bctn68bmta4ju")

func _ready() -> void:
	EventBus.qte_clicked.connect(_on_qte_click)

## Generates count randomized NPC_Resource instances, renders them as clickable lineup
## entries, and registers them with Global.customers_seen.
## count: The number of customers to generate and display.
func spawn_lineup(count: int) -> void:
	_clear_lineup()

	var npcs: Array[NPC_Resource] = []

	for i in count:
		var npc = NPC_Resource.new()
		npc.build_random()
		npcs.append(npc)

		var item : Control = QTE_ITEM.instantiate()
		item.npc_data = npc
		item.active = false
		item.scale = Vector2(0.75, 0.75)
		item.gui_input.connect(_on_item_gui_input.bind(npc, item))
		lineup_container.add_child(item)
		item.position += Vector2(256 * i, 0)

	Global.register_customers(npcs)

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
		#Temporarily okay. Rename
		EventBus.qte_clicked.emit(npc)
		print(item, npc)

		_check_customers()


func _check_customers() -> void:
	var flag = false
	for child in lineup_container.get_children():
		if child.npc_data.has_firework():
			flag = true
		else:
			flag = false
			break
	if flag:
		$EndButton.show()


func _on_qte_click() -> void:
	_check_customers()


func _on_end_button_pressed() -> void:
	for customer in lineup_container.get_children():
		var firework = customer.npc_data.get_firework()
		Global.fireworks_to_launch.append(firework)
	Global.start_transition(LAUNCH, Global.TRANSITIONS.DEFAULT)
