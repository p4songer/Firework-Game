extends RigidBody2D

@onready var parts: CPUParticles2D = $CPUParticles2D
var can_emit_signal : bool = false

func _ready() -> void:
	parts.emitting = true


func _on_cpu_particles_2d_finished() -> void:
	if can_emit_signal: EventBus.star_finished_emitting.emit()
