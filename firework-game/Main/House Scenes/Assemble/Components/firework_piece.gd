extends Control

@export var is_first: bool = false
@export var component: FireworkComponent

@onready var mouse_timer: Timer = $MouseTimer
@onready var fuse_out: Line2D = $FuseOut
@onready var fuse_out_area: Area2D = $FuseOut/FuseOutArea

var connected_firework: Node
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var active_menu : Control

var context_menu = preload("uid://blks5xe5qjutm")

## Returns the FireworkComponent assigned to this piece.
func get_component() -> FireworkComponent:
	return component

## Returns true if connecting this piece's fuse_out to proposed_target would
## create a cycle in the chain. Used to reject invalid connections before committing.
## proposed_target: The firework_piece node the player is attempting to connect to.
func would_create_loop(proposed_target: Node) -> bool:
	var current: Node = proposed_target
	var visited: Dictionary = {}
	while current != null:
		if current == self:
			return true
		if visited.has(current):
			break
		visited[current] = true
		current = current.connected_firework
	return false

## Handles fuse_out drag initiation and connection commit on mouse release.
func _on_fuse_out_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		dragging = true
		drag_offset = fuse_out_area.position - get_global_mouse_position()
		$FuseOut/FuseOutArea/DragIndicatorOut.show()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		dragging = false
		$FuseOut/FuseOutArea/DragIndicatorOut.hide()
		if fuse_out_area.has_overlapping_areas():
			var connection_made: bool = false
			for area: Area2D in fuse_out_area.get_overlapping_areas():
				if area.is_in_group("fuse_in") and not area.get_parent().is_first:
					var target: Node = area.get_parent()
					if would_create_loop(target):
						push_warning("Connection rejected: would create a loop.")
						break
					fuse_out_area.global_position = area.global_position
					fuse_out.set_point_position(1, fuse_out_area.position)
					connected_firework = target
					connection_made = true
					break
			if not connection_made:
				fuse_out_area.position = fuse_out.get_point_position(0)
				fuse_out.remove_point(1)
				if connected_firework:
					connected_firework = null
		else:
			fuse_out_area.position = fuse_out.get_point_position(0)
			fuse_out.remove_point(1)
			if connected_firework:
				connected_firework = null

## Extends the fuse_out line to follow the mouse while dragging.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and dragging:
		fuse_out_area.position = get_global_mouse_position() + drag_offset
		if fuse_out.get_point_count() > 1:
			fuse_out.set_point_position(1, fuse_out_area.position)
		else:
			fuse_out.add_point(fuse_out_area.position)


func _get_new_menu() -> void:
	if active_menu:
		print_debug("killing active menu")
		active_menu.queue_free()
	print_debug("adding new menu")
	var new_menu = context_menu.instantiate()
	add_child(new_menu)
	new_menu.global_position = get_global_mouse_position()
	new_menu.z_index = 1
	new_menu.activate(true)


func _on_overlap_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(
		MOUSE_BUTTON_LEFT) and not dragging:
		print("showing context")
		_get_new_menu()