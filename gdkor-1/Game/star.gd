extends RigidBody2D

@onready var trail: CPUParticles2D = $Trail
@onready var break_part: CPUParticles2D = $Break

var can_emit_signal : bool = false

func _ready() -> void:
	trail.emitting = true


func _on_trail_finished() -> void:
	if can_emit_signal: EventBus.star_finished_emitting.emit()
	break_part.emitting = true
