extends RigidBody2D

@onready var parts: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	parts.emitting = true
