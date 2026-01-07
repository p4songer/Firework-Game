extends Node2D

enum BREAK_PATTERN {
	FLOWER, CRACKLE, BROCADE, PALM
}

const CRACKLE_EFFECT = preload("uid://erboc5klvgf")
const STAR = preload("uid://c6fgnywnyo63w")

var last_area_clicked : Area2D
var active_area : Area2D

# This is for setting menu buttons
var effects_dict = {
	BREAK_PATTERN.FLOWER: "flower",
	BREAK_PATTERN.CRACKLE: "crackle",
	BREAK_PATTERN.BROCADE: "brocade",
	BREAK_PATTERN.PALM: "palm"
}
# TODO make fish effect
var F_METHODS : Dictionary = {
	BREAK_PATTERN.FLOWER: _flower,
	BREAK_PATTERN.CRACKLE: _crackle,
	BREAK_PATTERN.BROCADE: _brocade,
	BREAK_PATTERN.PALM: _palm,
}

@onready var panel: PanelContainer = $PCnt
@onready var color_menu: MenuButton = $PCnt/TabContainer/Color
@onready var effect_menu: MenuButton = $PCnt/TabContainer/Effect
@onready var particles: CPUParticles2D = $Particles


@onready var lift_data : FireworkResource = FireworkResource.new()
@onready var effect_data : FireworkResource = FireworkResource.new()
@onready var break_data : FireworkResource = FireworkResource.new()

#func _ready() -> void:
	#for area in self.get_children():
		#if area is Area2D:
			#area.mouse_entered.connect(_on_mouse_entered.bind(area))
			#area.mouse_exited.connect(_on_mouse_exited.bind(area))
	#
	##Prepare menus
	#var col_pop = color_menu.get_popup()
	#col_pop.index_pressed.connect(_on_color_selected)
	##var popup_arr = Global.get_dict_array("text")
	##for p in popup_arr:
		##col_pop.add_item(p)
	#
	#var eff_pop = effect_menu.get_popup()
	#eff_pop.index_pressed.connect(_on_effect_selected)
	#for p in effects_dict.values():
		#eff_pop.add_item(p)
#
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed():
		#if not active_area: 
			#last_area_clicked = null
			#panel.hide()
			#return
		#
		#last_area_clicked = active_area
		#panel.global_position = get_global_mouse_position()
		#panel.show()
#
#
#func _on_mouse_entered(which: Area2D) -> void:
	#active_area = which
#
#
#func _on_mouse_exited(which: Area2D) -> void:
	#if active_area == which:
		#active_area = null


func _on_color_selected(index: int) -> void:
	Global.color_index = index
	#FIXME refactor to use resources.
	#match last_area_clicked.name:
		#"Break":
			#break_data.main_color = Global.get_dict_item("color")
		#"Effect":
			#effect_data.main_color = Global.get_dict_item("color")
		#"Lifting":
			#lift_data.main_color = Global.get_dict_item("color")


func _on_effect_selected(index: int) -> void:
	match last_area_clicked.name:
		"Break":
			break_data.effect = index
		"Effect":
			effect_data.effect = index
		"Lifting":
			lift_data.effect = index


func _on_tab_container_tab_clicked(tab: int) -> void:
	$PCnt/TabContainer.get_child(tab).show_popup()

#FIXME Make sure this isn't needed.
#func update_text() -> void:
	#EventBus.color_changed.emit(Global.get_dict_item("color"))


func display(data : IngredientResource) -> void:
	(F_METHODS[data.effect]).call(data.ing_color)


#func toggle_sprite() -> void:
	#$Sprite2D.visible = not $Sprite2D.visible
	#self.rotation = 0


func _flower(color_ref : Color) -> void:
	particles.emitting = true
	particles.self_modulate = color_ref


func _brocade(color_ref: Color) -> void:
	for i in 30:
		var new_star : RigidBody2D = STAR.instantiate()
		self.add_child(new_star)
		new_star.apply_central_impulse(Vector2.UP.rotated(self.rotation) * 1000)
		new_star.modulate = color_ref
		self.rotate(randf_range(0.75, 2.5))


func _palm(color_ref: Color) -> void:
	self.rotation_degrees = randf_range(-60, 60)
	#TODO Make number variable
	for i in 10:
		var new_star : RigidBody2D = STAR.instantiate()
		self.add_child(new_star)
		var x_dir = randf_range(-0.75, 0.75) # figure out minx maxx
		var y_dir = randf_range(-0.25, -1.0)
		var direction = Vector2(x_dir, y_dir).rotated(self.rotation).normalized() * 1000
		new_star.apply_central_impulse(direction)
		new_star.modulate = color_ref


func _crackle(color_ref : Color) -> void:
		particles.color_ramp = CRACKLE_EFFECT
		particles.lifetime = 2.0
		particles.lifetime_randomness = 1
		particles.self_modulate = color_ref
		particles.emitting = true
