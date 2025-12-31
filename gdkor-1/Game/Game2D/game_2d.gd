extends Node2D

const TARGET = preload("uid://mgbxletqsajm")

func _ready() -> void:
	spawn_target.call_deferred()
	EventBus.target_clicked.connect(_on_target_clicked)


func spawn_target() -> void:
	var new_target: RigidBody2D = TARGET.instantiate()
	var pos_x = Global.RNG.randf_range(0, (get_viewport_rect().size.x / 2.0) - 64.0)
	var pos_y = Global.RNG.randf_range(0, (get_viewport_rect().size.y / 2.0) - 64.0)
	self.add_child(new_target)
	new_target.position = Vector2(pos_x, pos_y)
	new_target.apply_central_impulse(Vector2(-pos_x, -pos_y) * Global.RNG.randi_range(1, 5))


func _on_target_clicked(_points: int) -> void:
	spawn_target.call_deferred()
