extends Node2D

#TODO Make this scene visible at all times, but inactive until end of day.
@onready var cam: Camera2D = $Camera2D
@onready var sequence_delay: Timer = $SequenceDelay
@onready var launch_pos: Node2D = $LaunchPos

@export var testing_firework : IngredientResource
@export var testing_array : Array[FireworkComponent]

var launching_active: bool = false
var is_on_screen : bool = false
var currently_launching : bool = false
var launch_queue : Array[FireworkResource] = []
var firework_queue : Array[FireworkComponent] = []
var active_tween : Tween
var active_firework : CPUParticles2D

signal firework_complete()

# func _ready() -> void:
# 	firework_complete.connect(_on_firework_complete)
# 	var path = "Main/Testing Resources/"
# 	var dir = ResourceLoader.list_directory(path)
# 	for data in dir:
# 		var inst = load(path + data)
# 		testing_array.append(inst)
# 	var fire = FireworkResource.new()
# 	fire.sequence = testing_array
# 	set_active([fire])


func _input(_event: InputEvent) -> void:
	if not is_on_screen: return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not currently_launching:
		EventBus.display_started.emit()


func begin_launch_sequence(firework: FireworkResource) -> void:
	currently_launching = true
	firework_queue = firework.sequence.duplicate()
	print_debug("BEGIN SEQUENCE: ", firework_queue)

	launch_new()


func _on_sequence_delay_timeout() -> void:
	if firework_queue.is_empty():
		firework_complete.emit()
		return
	# if testing_array.is_empty():
	# 	print_debug("EMPTY")
	# 	currently_launching = false
	# 	sequence_delay.stop()
	# 	return
	launch_new()


func launch_new() -> void:
	print_debug("LAUNCH")
	var fire_inst = GlobalRef.DICT[GlobalRef.INDEX.FIREWORK].instantiate()
	launch_pos.add_child(fire_inst)
	# var component = testing_array[0]
	var component = firework_queue[0]
	fire_inst.launch(component.ingredient)
	if active_tween: active_tween.kill()
	active_tween = create_tween()
	active_tween.tween_property(fire_inst, "position", Vector2(0, - 1920), component.fuse_length)
	active_tween.finished.connect(_lift_finished)
	active_firework = fire_inst
	
	sequence_delay.wait_time = component.fuse_length
	sequence_delay.start()


func _lift_finished() -> void:
	print("LIFT FINISHED")
	active_firework.display(firework_queue.pop_front().ingredient)
	# active_firework.display(testing_array.pop_front().ingredient)


func _on_firework_complete() -> void:
	print_debug("FIREWORK COMPLETE.")
	if launch_queue.is_empty():
		print_debug("LAUNCH QUEUE EMPTY")
		currently_launching = false
		sequence_delay.stop()
	else:
		print_debug("LAUNCH NEXT")
		begin_launch_sequence(launch_queue.pop_front())


func set_active(fireworks: Array[FireworkResource]) -> void:
	if fireworks.is_empty():
		print_debug("NO FIREWORKS TO LAUNCH")
		return
	print_debug("SETTING ACTIVE: ", fireworks)
	cam.enabled = true
	launch_queue = fireworks
	launching_active = true
	$Camera2D.enabled = true
	begin_launch_sequence(launch_queue.pop_front())


func _on_screen_exited() -> void:
	is_on_screen = false

func _on_screen_entered() -> void:
	is_on_screen = true
