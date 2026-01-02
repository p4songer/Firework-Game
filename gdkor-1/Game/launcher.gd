extends Node2D

const STAR = preload("uid://c6fgnywnyo63w")

func _ready() -> void:
	#TODO make trail work.
	print("Need to make one for a trail.")
	## This is for brocade
	#for i in 30:
		#var new_star : RigidBody2D = STAR.instantiate()
		#self.add_child(new_star)
		#new_star.apply_central_impulse(Vector2.UP.rotated(self.rotation) * 1000)
		#self.rotate(randf_range(0.75, 2.5))
	## This is for Palm
	#self.rotation_degrees = randf_range(-60, 60)
	#await get_tree().create_timer(1.0).timeout
	##TODO Make number variable
	#for i in 10:
		#var new_star : RigidBody2D = STAR.instantiate()
		#self.add_child(new_star)
		#var x_dir = randf_range(-0.75, 0.75) # figure out minx maxx
		#var y_dir = randf_range(-0.25, -1.0)
		#var direction = Vector2(x_dir, y_dir).rotated(self.rotation).normalized() * 1000
		#new_star.apply_central_impulse(direction)
