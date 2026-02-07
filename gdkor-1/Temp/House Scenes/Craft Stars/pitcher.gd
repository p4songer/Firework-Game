extends Sprite2D

@export var color : Color
@export var color_name : String

var dragging : bool = false
var pouring : bool = false

const GRAIN = preload("uid://bvjnv5efn6c7f")

func _ready() -> void:
	$Label.text = color_name


func _process(_delta: float) -> void:
	if dragging:
		self.global_position = get_global_mouse_position()
	if pouring:
		await get_tree().create_timer(0.1).timeout
		var new_g = GRAIN.instantiate()
		new_g.global_position = self.global_position
		new_g.modulate = color
		get_parent().add_grain(new_g)


func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("click"):
		dragging = true
	if event is InputEventMouseButton and Input.is_action_just_released("click"):
		dragging = false


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("pitcher"):
		pouring = true



func _on_area_exited(area: Area2D) -> void:
	if not area.is_in_group("pitcher"):
		pouring = false
