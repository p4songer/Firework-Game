extends Node2D

@export var spin_count : int = 5
@onready var obj: Node2D = $obj
var dir_array : Array

func _ready() -> void:
	for i in $points.get_child_count():
		$points.get_child(i).area_entered.connect(_on_point_entered.bind(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	obj.look_at(get_global_mouse_position())


func _on_point_entered(_area : Area2D, idx: int) -> void:
	dir_array.append(idx)
	if dir_array.size() < 4: return
	# if we have 4 elements, check the sequence.
	if dir_array.size() > 4:
		dir_array.remove_at(0)
	var total = 0
	for i in dir_array:
		total += i
	if total == 6:
		spin_count -= 1
		if spin_count == 0:
			EventBus.spin_finished.emit()
		#TODO emit signal here.
		dir_array.clear()
