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
