extends Sprite2D

enum BREAK_PATTERN {
	FLOWER, CRACKLE, BROCADE, PALM
}

const CRACKLE_EFFECT = preload("uid://erboc5klvgf")
const STAR = preload("uid://c6fgnywnyo63w")

var last_area_clicked : Area2D
var active_area : Area2D
var popup : PopupMenu

# This is for setting menu buttons
var effects_dict = {
	0: "flower",
	1: "crackle",
	2: "brocade",
	3: "palm"
}

@onready var panel: PanelContainer = $PCnt
@onready var color_menu: MenuButton = $PCnt/TabContainer/Color
@onready var effect_menu: MenuButton = $PCnt/TabContainer/Effect
@onready var particles: CPUParticles2D = $Particles


@onready var lift_data : FireworkResource = FireworkResource.new()
@onready var filler_data : FireworkResource = FireworkResource.new()
@onready var break_data : FireworkResource = FireworkResource.new()

func _ready() -> void:
	for area in self.get_children():
		if area is Area2D:
			area.mouse_entered.connect(_on_mouse_entered.bind(area))
			area.mouse_exited.connect(_on_mouse_exited.bind(area))
	
	#Prepare menus
	var col_pop = color_menu.get_popup()
	col_pop.index_pressed.connect(_on_color_selected)
	var popup_arr = Global.get_dict_array("text")
	for p in popup_arr:
		col_pop.add_item(p)
	
	var eff_pop = effect_menu.get_popup()
	eff_pop.index_pressed.connect(_on_effect_selected)
	for p in effects_dict.values():
		eff_pop.add_item(p)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if not active_area: return
		
		last_area_clicked = active_area
		panel.global_position = get_global_mouse_position()
		panel.show()


func _on_mouse_entered(which: Area2D) -> void:
	active_area = which


func _on_mouse_exited(which: Area2D) -> void:
	if active_area == which:
		active_area = null


func _on_menu_button_about_to_popup() -> void:
	pass


func _on_color_selected(index: int) -> void:
	Global.color_index = index
	update_text()


func _on_effect_selected(index: int) -> void:
	match last_area_clicked:
		"Break":
			break_data.effect = index
		"Filler":
			filler_data.effect = index
		"Lifting":
			lift_data.effect = index


func _on_tab_container_tab_clicked(tab: int) -> void:
	$PCnt/TabContainer.get_child(tab).show_popup()


func update_text() -> void:
	EventBus.color_changed.emit(Global.get_dict_item("color"))



func next_stage() -> void:
	particles.emitting = true
