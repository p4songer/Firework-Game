extends Node2D

enum BREAK_PATTERN {
	FLOWER, CRACKLE, BROCADE, PALM
}

const CRACKLE_EFFECT = preload("uid://erboc5klvgf")
const STAR = preload("uid://c6fgnywnyo63w")

var last_area_clicked : Area2D
var active_area : Area2D

@export var is_trail : bool = false:
	set(new):
		is_trail = new
		if is_trail: 
			trail.emitting = true
@export var is_mine : bool = false

@onready var trail: CPUParticles2D = $Trail

# TODO make fish effect
var F_METHODS : Dictionary = {
	BREAK_PATTERN.FLOWER: _flower,
	BREAK_PATTERN.CRACKLE: _crackle,
	BREAK_PATTERN.BROCADE: _brocade,
	BREAK_PATTERN.PALM: _palm,
}

var exp_array : Array = [
	preload("uid://cjag0mx15yque"), preload("uid://d2e2mc78eobpi"), preload("uid://bhn67hnt0je65"),
	preload("uid://bw2y274anh3we"), preload("uid://miqxy0fsxpdh")
]

func display(data : IngredientResource) -> void:
	(F_METHODS[data.effect]).call(data.ing_color)
	if is_trail : trail.emitting = false


func _flower(color_ref : Color) -> void:
	_play_random()
	if is_mine:
		self.direction = Vector2(0, -1)
		self.spread = 15.0
	self.emitting = true
	self.self_modulate = color_ref


func _brocade(color_ref: Color) -> void:
	_play_random()
	var num = 10 if is_mine else 30
	self.rotation_degrees = -5 
	for i in num:
		var new_star : RigidBody2D = STAR.instantiate()
		self.add_child(new_star)
		new_star.apply_central_impulse(Vector2.UP.rotated(self.rotation) * 1000)
		new_star.modulate = color_ref
		self.rotate(randf_range(0.5, 3.0))


func _palm(color_ref: Color) -> void:
	_play_random()
	self.rotation_degrees = randf_range(-60, 60) if not is_mine else 0.0

	for i in 10:
		var new_star : RigidBody2D = STAR.instantiate()
		self.add_child(new_star)
		var x_dir = randf_range(-0.75, 0.75) # figure out minx maxx
		var y_dir = randf_range(-0.25, -1.0)
		var direction = Vector2(x_dir, y_dir).rotated(self.rotation).normalized() * 1000
		new_star.apply_central_impulse(direction)
		new_star.modulate = color_ref


func _crackle(color_ref : Color) -> void:
	if is_mine:
		self.direction = Vector2(0, -1)
		self.spread = 15.0
	self.color_ramp = CRACKLE_EFFECT
	self.lifetime = 2.0
	self.lifetime_randomness = 1
	self.self_modulate = color_ref
	self.emitting = true
	
	$SFX.stream = preload("uid://chtil3nern5rp")
	$SFX.play()


func _play_random() -> void:
	exp_array.shuffle()
	$SFX.stream = exp_array[0]
	$SFX.play()
