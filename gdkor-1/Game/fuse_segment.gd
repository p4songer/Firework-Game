extends CharacterBody2D

var dragging : bool = false
var mouse_offset : Vector2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not dragging:
		velocity += get_gravity() * delta
	else:
		position = get_global_mouse_position()

	move_and_slide()

#
#extends Node2D
#
#func _on_fuse_segment_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print("got input")
	#if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#$Assembly/Dragger.dragging = true
		#print("click")
#
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_released():
		#$Assembly/Dragger.dragging = false
