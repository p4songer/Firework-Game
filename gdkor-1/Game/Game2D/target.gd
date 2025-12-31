extends RigidBody2D


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		EventBus.target_clicked.emit(1.5)
		$SFX.play()
		await $SFX.finished
		queue_free.call_deferred()
