extends Node2D

@onready var bids: Node2D = $Bids
@onready var cam: Camera2D = $Camera2D
@onready var money: Label = $UI/Money
@onready var delay: Timer = $Delay

var current_money : float = 0.0

var bid_array : Array

const QTE_ITEM = preload("uid://l2s6ioimdxc")

func _ready() -> void:
	EventBus.qte_clicked.connect(_on_qte_click)
	
	# TODO make this work for each item made eventually.
	for i in 25:
		var new_item = QTE_ITEM.instantiate()
		new_item.time = randf_range(0.1, 0.5)
		new_item.money = randf_range(5.0, 500.0)
		new_item.scale = Vector2(0.75, 0.75)
		var rand_x = randf_range(-900, 900)
		var rand_y = randf_range(-450, 450)
		new_item.global_position = Vector2(rand_x, rand_y)
		
		bid_array.append(new_item)


func _process(_delta: float) -> void:
	cam.global_position = get_global_mouse_position()


func _on_qte_click(dollars: float) -> void:
	current_money += dollars
	money.text = "%0.2f" % current_money


func _on_delay_timeout() -> void:
	# Restart with random time
	delay.wait_time = randf_range(0.5, 3.0)
	delay.start()
	
	# Check to spawn bid
	if bids.get_child_count() < 5 and not bid_array.is_empty():
		bids.add_child(bid_array.pop_front())
