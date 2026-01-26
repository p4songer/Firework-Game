extends Camera2D

@export var speed : float = 2.5

var active_tween : Tween
var target : Node2D

func _process(delta: float) -> void:
	if target:
		self.global_position = lerp(self.global_position, target.global_position, speed * delta)
		
