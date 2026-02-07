extends Node2D




func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("pitcher"):
		print("area ", $Sprite2D/Area2D.get_overlapping_bodies().size())
		print("GH: ", $GrainHolder.get_child_count())
