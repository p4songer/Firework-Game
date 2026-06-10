extends RigidBody2D

var entered = false

func _ready() -> void:
	EventBus.craft_stars_completed.connect(_on_craft_stars_completed)


func _on_screen_exited() -> void:
	self.queue_free()


func _on_craft_stars_completed(_final_color: Color, _other) -> void:
	self.queue_free()


func _on_timer_timeout() -> void:
	if not entered:
		self.queue_free()


func set_entered() -> void:
	entered = true
