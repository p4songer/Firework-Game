extends TextureRect

@export var color : Color
@export var color_name : String

var origin : Vector2
var drag_origin : Vector2
var dragging : bool = false

const GRAIN = preload("uid://bvjnv5efn6c7f")

var active_tween : Tween

func set_data(arr : Array) -> void:
	color = arr[0]
	color_name = arr[1]
	$Label.text = color_name


func _process(_delta: float) -> void:
	if dragging:
		self.position = get_global_mouse_position() + drag_origin


func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("click"):
		dragging = true
		origin = self.position
		drag_origin = self.position - get_global_mouse_position()
	if event is InputEventMouseButton and Input.is_action_just_released("click"):
		dragging = false
		self.position = origin


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("pitcher"):
		if active_tween: active_tween.kill()
		active_tween = create_tween().set_parallel()
		active_tween.tween_property(self, "rotation_degrees", -115, 0.3)
		await active_tween.finished
		$Delay.start()


func _on_area_exited(area: Area2D) -> void:
	if not area.is_in_group("pitcher"):
		$Delay.stop()
		if active_tween: active_tween.kill()
		active_tween = create_tween().set_parallel()
		active_tween.tween_property(self, "rotation_degrees", 0, 0.3)


func _on_delay_timeout() -> void:
	var new_g = GRAIN.instantiate()
	new_g.position = $Marker2D.global_position
	new_g.modulate = color
	EventBus.new_grain.emit(new_g)
