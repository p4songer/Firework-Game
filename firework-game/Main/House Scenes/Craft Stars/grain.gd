extends RigidBody2D

func _ready() -> void:
	EventBus.craft_stars_completed.connect(_on_craft_stars_completed)


func _on_screen_exited() -> void:
	self.queue_free()


func _on_craft_stars_completed(_final_color: Color) -> void:
	self.queue_free()
