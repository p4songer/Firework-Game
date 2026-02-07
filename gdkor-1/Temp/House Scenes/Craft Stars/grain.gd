extends RigidBody2D

func _on_screen_exited() -> void:
	self.queue_free()
