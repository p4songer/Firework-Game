extends Camera2D

@export var speed : float = 2.5

var active_tween : Tween
var target : Node2D#:
	#set(new_target):
		#target = new_target
		#if new_target == null : return
		#if active_tween: active_tween.kill()
		#
		#active_tween = create_tween()
		#active_tween.tween_property(self, "position", new_target.global_position, 1.0)

func _process(delta: float) -> void:
	# FIXME This isn't going to work.
	if target:
		self.global_position = lerp(self.global_position, target.global_position, speed * delta)
		
