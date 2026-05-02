extends Node2D

#TODO Make this scene visible at all times, but inactive until end of day.

@onready var sequence_delay: Timer = $SequenceDelay
@onready var launch_pos: Node2D = $LaunchPos

@export var testing_firework : IngredientResource
@export var testing_array : Array

var currently_launching : bool = false
var active_tween : Tween
var active_firework : CPUParticles2D
 
func _ready() -> void:
	var path = "res://Game/Refactored/Testing Resources/"
	var dir = ResourceLoader.list_directory(path)
	for data in dir:
		var inst = load(path + data)
		testing_array.append(inst)


func _input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not currently_launching:
		begin_launch_sequence()


func begin_launch_sequence() -> void:
	currently_launching = true
	launch_new()


func _on_sequence_delay_timeout() -> void:
	if testing_array.is_empty():
		print("EMPTY")
		currently_launching = false
		sequence_delay.stop()
		return
	launch_new()


func launch_new() -> void:
	print("LAUNCH")
	var fire_inst = GlobalRef.DICT[GlobalRef.INDEX.FIREWORK].instantiate()
	launch_pos.add_child(fire_inst)
	var component = testing_array[0]
	fire_inst.launch(component.ingredient)
	if active_tween: active_tween.kill()
	active_tween = create_tween()
	active_tween.tween_property(fire_inst, "global_position", Vector2(0, 0), component.fuse_length)
	active_tween.finished.connect(_lift_finished)
	active_firework = fire_inst
	
	sequence_delay.wait_time = component.fuse_length
	sequence_delay.start()


func _lift_finished() -> void:
	active_firework.display(testing_array.pop_front().ingredient)
