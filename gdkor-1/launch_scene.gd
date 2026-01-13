extends Node2D

var fuse_lit : bool = false

@onready var mine: CPUParticles2D = $FireworkStages/Mine
@onready var fire_break: CPUParticles2D = $FireworkStages/Break
@onready var effect: CPUParticles2D = $FireworkStages/Effect

@export var destination : Vector2

#FIXME Make this work
#TODO maybe use a video recording for star animation?
#TODO Make star effects available and work.

func _ready() -> void:
	EventBus.launch_firework.connect(launch_firework)
	EventBus.star_finished_emitting.connect(_on_star_finished)


func _process(delta: float) -> void:
	if fuse_lit:
		$Tube/Path2D/PathFollow2D.progress_ratio += 0.75 * delta
		if is_equal_approx(1.0, $Tube/Path2D/PathFollow2D.progress_ratio):
			await get_tree().create_timer(1.0).timeout
			$Tube/Path2D/PathFollow2D/FuseParticles.emitting = false
			fuse_lit = false
			launch_firework()



func launch_firework() -> void:
	$LaunchTimer.start()
	fire_break.global_position = get_launch_pos()
	var ingredient = Global.active_fireworks.pop_front()
	mine.display(ingredient)
	
	var tween = create_tween()
	tween.tween_property(fire_break, "global_position", destination, 1.5)
	tween.finished.connect(_on_star_finished)
	effect.global_position = destination
	
	fire_break.modulate = ingredient.ing_color 
	fire_break.is_trail = true
	
	#if $UI.is_whistle:
		#whistle_arr.shuffle()
		#$Whistle.stream = whistle_arr[0]
		#$Whistle.play()
	#else:
		#lift_arr.shuffle()
		#$Whistle.stream = lift_arr[0]
		#$Whistle.play()


func get_launch_pos() -> Vector2:
	return $Tube.position


func _on_texture_button_pressed() -> void:
	fuse_lit = true
	$Tube/Path2D/PathFollow2D/FuseParticles.emitting = true
	$Tube/Path2D/PathFollow2D/TextureButton.hide()


func _on_star_finished() -> void:
	# stop moving camera
	#$Camera2D.target = null
	#
	#firework.global_position = $Camera2D.global_position
	fire_break.display(Global.active_fireworks.pop_front())
	$DelayTimer.start()
	$Camera2D.target = effect
