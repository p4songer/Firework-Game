extends CanvasLayer

enum BREAK_PATTERN {
	FLOWER, CRACKLE, BROCADE, PALM
}

# pop out drawer stuff
@export var color_drawer_offset : Vector2
@export var fx_drawer_offset : Vector2
var color_drawer_out : bool = false
var fx_drawer_out : bool = false
var color_tween : Tween
var fx_tween : Tween

# click stuff in drawer stuff
var item_indexes : Dictionary = {}
var ing_in_hand : IngredientResource = null
var fx_in_hand : int = 0
var star_in_hand : Texture2D

# effects stuff
var fx_dict = {
	BREAK_PATTERN.FLOWER: "flower",
	BREAK_PATTERN.CRACKLE: "crackle",
	BREAK_PATTERN.BROCADE: "brocade",
	BREAK_PATTERN.PALM: "palm"
}

const CHEM_BOX = preload("uid://dfo8q7vyrt5g0")

var star_array : Array = [
	preload("uid://cwtfh7cjvrsoj"), preload("uid://dhjm0mv6od403"), preload("uid://bdql4f8kmscm2"), 
	preload("uid://caaxpsg6sd8ho"), preload("uid://b8bioafvnu7m3"),
	]

@onready var color_drawer: HBoxContainer = $ColorDrawer
@onready var fx_drawer: HBoxContainer = $FxDrawer

func _ready() -> void:
	EventBus.request_ingredient.connect(_on_request_ingredient)
	EventBus.prepare_launch.connect(_on_prepare_launch)
	fx_drawer_offset.x = get_viewport().get_visible_rect().size.x
	
	
	# populate color drawer
	for idx in Global.FIRE_RESOURCES.size():
		var new_button = CHEM_BOX.instantiate()
		var ing_res = Global.FIRE_RESOURCES[idx]
		new_button.data = ing_res
		$ColorDrawer/Grid.add_child(new_button)
	
		item_indexes[idx] = ing_res
		new_button.pressed.connect(_on_ingredient_pressed.bind(idx))
	
	# populate effects drawer
	for fx in fx_dict.keys():
		var new_button = CHEM_BOX.instantiate()
		var ing_res = Global.EFFECT_RESOURCES[fx]
		new_button.data = ing_res
		new_button.is_effect = true
		$FxDrawer/Grid.add_child(new_button)
		new_button.pressed.connect(_on_effect_pressed.bind(fx))
	# Add stars to effects drawer.
	for star in star_array:
		var new_button = CHEM_BOX.instantiate()
		var ing_res = IngredientResource.new()
		ing_res.star_sprite = star; ing_res.ing_sprite = star; ing_res.ing_name = "Star Variation"
		new_button.data = ing_res; new_button.is_effect = true
		$FxDrawer/Grid.add_child(new_button)
		new_button.scale_button(Vector2(2, 2))
		new_button.pressed.connect(_on_star_pressed.bind(star))
		
	# Position drawer stuff.
	color_drawer.position.x = $ColorDrawer/Grid.size.x + ($ColorDrawer/Grid.size.x / 3)
	fx_drawer.position.x = $FxDrawer/Grid.size.x + ($FxDrawer/Grid.size.x / 3)
	fx_drawer.position.y = fx_drawer_offset.y
	color_drawer_offset = color_drawer.position
	fx_drawer_offset = fx_drawer.position

func _on_color_button_pressed() -> void:
	Global.play_sfx()
	if color_tween: color_tween.kill()
	color_tween = create_tween()
	color_tween.set_ease(Tween.EASE_IN_OUT)
	color_tween.set_trans(Tween.TRANS_BACK)
	var final = color_drawer_offset if color_drawer_out else Vector2(
		color_drawer.size.x / 1.65, color_drawer_offset.y
		)
	color_tween.tween_property($ColorDrawer, "position", final, 0.5)
	
	color_drawer_out = not color_drawer_out


func _on_effect_button_pressed() -> void:
	Global.play_sfx()
	if fx_tween: fx_tween.kill()
	fx_tween = create_tween()
	fx_tween.set_ease(Tween.EASE_IN_OUT)
	fx_tween.set_trans(Tween.TRANS_BACK)
	var final = fx_drawer_offset if fx_drawer_out else Vector2(
		fx_drawer.size.x / 1.65, fx_drawer_offset.y
		)
	fx_tween.tween_property(fx_drawer, "position", final, 0.5)
	
	fx_drawer_out = not fx_drawer_out


func _on_ingredient_pressed(index : int) -> void:
	ing_in_hand = item_indexes[index]
	EventBus.color_button_pressed.emit()
	#_on_color_button_pressed()
	#if not fx_drawer_out:
		#_on_effect_button_pressed()


func _on_effect_pressed(index : int) -> void:
	fx_in_hand = index
	EventBus.effect_button_pressed.emit()
	#_on_effect_button_pressed()
	#if not color_drawer_out:
		#_on_color_button_pressed()


func _on_star_pressed(star : Texture2D) -> void:
	star_in_hand = star
	EventBus.effect_button_pressed.emit()


func _on_request_ingredient(requestor: Node2D) -> void:
	if ing_in_hand:
		requestor.ingredient = ing_in_hand
		#requestor.ingredient.ing_name = ing_in_hand.ing_name
		#requestor.ingredient.ing_color = ing_in_hand.ing_color
		ing_in_hand = null
	if star_in_hand:
		requestor.ingredient.star_sprite = star_in_hand
		star_in_hand = null
	requestor.ingredient.effect = fx_in_hand


func _on_prepare_launch() -> void:
	self.hide()
