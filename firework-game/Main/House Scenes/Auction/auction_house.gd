extends Node2D

#TODO Completely remove the camera/auction funcitonality in favor of customer lineups.
# includes this is where all customer UI should live.

@onready var bids: Node2D = $Bids
@onready var cam: Camera2D = $Camera2D
@onready var delay: Timer = $Delay

@export var active : bool = false:
	set(new):
		active = new
		if active:
			delay.start()
			$Camera2D.enabled = true
		else:
			delay.stop()
			$Camera2D.enabled = false

# var current_money : float = 0.0

var bid_array : Array

const QTE_ITEM = preload("uid://l2s6ioimdxc")

func _ready() -> void:
	for i in 25:
		var new_item = QTE_ITEM.instantiate()
		new_item.time = randf_range(0.1, 0.5)
		var new_npc = NPC_Resource.new()
		new_npc.build_random()
		new_item.npc_data = new_npc
		new_item.scale = Vector2(0.75, 0.75)
		var rand_x = randf_range(-900, 900)
		var rand_y = randf_range(-450, 450)
		new_item.global_position = Vector2(rand_x, rand_y)
		new_item.dying.connect(_on_qte_dying)
		
		bid_array.append(new_item)


func _process(_delta: float) -> void:
	cam.global_position = get_global_mouse_position()


func _on_delay_timeout() -> void:
	# Restart with random time
	delay.wait_time = randf_range(0.5, 3.0)
	delay.start()
	
	# Check to spawn bid
	if bids.get_child_count() < 5 and not bid_array.is_empty():
		bids.add_child(bid_array.pop_front())
		bids.get_child(-1).start()


func clear_house() -> void:
	for i in $Bids.get_children():
		i.queue_free()
	
	EventBus.room_completed.emit()


func _on_qte_dying(which) -> void:
	which.queue_free()
