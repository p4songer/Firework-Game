extends Node2D

#TODO Make it so that all fireworks bought in a day can be launched simultaniously
#or at least in a sequence. Customer reviews should populate around the spot they are located.

var ingredient : IngredientResource
var fuse_lit : bool = false:
	set(lit):
		fuse_lit = lit
		$FuseAnim.play("launch")
		$Tube/Path2D/PathFollow2D/FuseParticles.emitting = true
		var tween = create_tween()
		tween.tween_property($Tube/Path2D/PathFollow2D, "progress_ratio", 1.0, 0.75)
		await get_tree().create_timer(1.25).timeout
		launch_firework()

@onready var mine: CPUParticles2D = $FireworkStages/Mine
@onready var fire_break: CPUParticles2D = $FireworkStages/Break
@onready var effect: CPUParticles2D = $FireworkStages/Effect
@onready var cam: Camera2D = $Camera2D
@onready var sfx: AudioStreamPlayer = $SFX

@export var destination : Vector2


var whistle_arr : Array = [preload("uid://dd52q34uq2f1"), preload("uid://fb5jjrpt00tk")]
var lift_arr : Array = [
	preload("uid://dcc1xeh8vjkj0"), preload("uid://bg2rgv8001u0n")
]

var HOUSE_MANAGER = load("uid://cj73xl2uujryc")
var star_array : Array = [
	preload("uid://cwtfh7cjvrsoj"), preload("uid://dhjm0mv6od403"), preload("uid://bdql4f8kmscm2"),
	preload("uid://caaxpsg6sd8ho"), preload("uid://b8bioafvnu7m3")
]
const REVIEW = preload("uid://drq4tuq8bw3k6")

func _ready() -> void:
	#EventBus.launch_firework.connect(launch_firework)
	EventBus.star_finished_emitting.connect(_on_star_finished)
	EventBus.firework_finished.connect(_on_firework_finished)


func make_active() -> void:
	cam.enabled = true



func launch_firework() -> void:
	$Tube/Path2D/PathFollow2D/FuseParticles.emitting = false
	$LaunchTimer.start()
	fire_break.global_position = get_launch_pos()
	#TODO Make sure this isn't reusable for later.
	#var ingredient = Global.active_fireworks.pop_front()
	#mine.display(ingredient)
	#fire_break.trail.texture = ingredient.star_sprite
	
	var tween = create_tween()
	tween.tween_property(fire_break, "position", destination, 1.2)
	tween.finished.connect(_on_star_finished)
	#effect.global_position = destination
	fire_break.is_trail = true
	fire_break.launch(ingredient)
	
	if Global.is_whistle:
		whistle_arr.shuffle()
		sfx.stream = whistle_arr[0]
		sfx.play()
	else:
		lift_arr.shuffle()
		sfx.stream = lift_arr[0]
		sfx.play()


func get_launch_pos() -> Vector2:
	return $Tube.global_position


func _on_texture_button_pressed() -> void:
	fuse_lit = true
	$Tube/Path2D/PathFollow2D/FuseParticles.emitting = true
	$Tube/Path2D/PathFollow2D/TextureButton.hide()


func _on_star_finished() -> void:
	fire_break.display(ingredient)
	#$DelayTimer.start()
	#$Camera2D.target = effect


func _on_delay_timer_timeout() -> void:
	var rand_x = randf_range(fire_break.global_position.x - 1500, fire_break.global_position.x + 1500)
	var rand_y = randf_range(fire_break.global_position.y - 1750, fire_break.global_position.y + 1750)
	effect.global_position = Vector2(rand_x, rand_y)
	#effect.display(Global.active_fireworks.pop_front())


func _on_launch_timer_timeout() -> void:
	$Camera2D.target = fire_break


func _on_firework_finished() -> void:
	var new = REVIEW.instantiate()
	new.data = Global.review_array[-1]
	new.data.get_review(ingredient)
	new.data.npc_sprite = star_array.pick_random()
	$LaunchUI/Vbox.add_child(new)
	
	await get_tree().create_timer(1.5).timeout
	$LaunchUI.show()


func _on_return_pressed() -> void:
	EventBus.room_completed.emit()
	Global.start_transition(HOUSE_MANAGER, Global.TRANSITIONS.DEFAULT)


func temp_display(thingy) -> void:
	$FireworkStages/Break.display(thingy)
