extends Control

@export var is_first : bool = false

@onready var fuse_out: Line2D = $FuseOut
@onready var fuse_out_area: Area2D = $FuseOut/FuseOutArea

var connected_firework : Node

var dragging : bool = false
var drag_offset : Vector2 = Vector2.ZERO 

func _on_fuse_out_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print_debug("start dragging from fuse in area.")
		dragging = true
		drag_offset = fuse_out_area.position - get_global_mouse_position()
		$FuseOut/FuseOutArea/DragIndicatorOut.show()

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		dragging = false
		$FuseOut/FuseOutArea/DragIndicatorOut.hide()
		if fuse_out_area.has_overlapping_areas():
			var connection_made: bool = false
			for area in fuse_out_area.get_overlapping_areas():
				if area.is_in_group("fuse_in") and not area.get_parent().is_first:
					print_debug("making connection")
					fuse_out_area.global_position = area.global_position
					fuse_out.set_point_position(1, fuse_out_area.position)
					connected_firework = area.get_parent()
					connection_made = true
					break
			if not connection_made:
				fuse_out_area.position = fuse_out.get_point_position(0)
				fuse_out.remove_point(1)

				if connected_firework: connected_firework = null
		else:
			fuse_out_area.position = fuse_out.get_point_position(0)
			fuse_out.remove_point(1)

			if connected_firework: connected_firework = null
				
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and dragging:
		fuse_out_area.position = get_global_mouse_position() + drag_offset
		if fuse_out.get_point_count() > 1:
			fuse_out.set_point_position(1, fuse_out_area.position)
		else:
			fuse_out.add_point(fuse_out_area.position)
