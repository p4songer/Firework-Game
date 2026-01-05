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

# effects stuff
var fx_dict = {
	BREAK_PATTERN.FLOWER: "flower",
	BREAK_PATTERN.CRACKLE: "crackle",
	BREAK_PATTERN.BROCADE: "brocade",
	BREAK_PATTERN.PALM: "palm"
}
# TODO make fish effect
var FX_METHODS : Dictionary = {
	BREAK_PATTERN.FLOWER: _flower,
	BREAK_PATTERN.CRACKLE: _crackle,
	BREAK_PATTERN.BROCADE: _brocade,
	BREAK_PATTERN.PALM: _palm,
}

func _ready() -> void:
	EventBus.request_ingredient.connect(_on_request_ingredient)
	
	# populate first drawer
	for idx in Global.FIRE_RESOURCES.size():
		var new_button = Button.new()
		var ing_res = Global.FIRE_RESOURCES[idx]
		new_button.icon = ing_res.ing_sprite
		new_button.text = ing_res.ing_name
		new_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
		$Drawer/GridContainer.add_child(new_button)
	
		item_indexes[idx] = ing_res
		new_button.pressed.connect(_on_ingredient_pressed.bind(idx))
	
	# populate second drawer
	for fx in fx_dict.keys():
		var new_button = Button.new()
		var ing_res = Global.EFFECT_RESOURCES[fx]
		new_button.icon = ing_res.ing_sprite
		new_button.text = ing_res.ing_name
		new_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
		$Effects/Drawer/Grid.add_child(new_button)
		
		new_button.pressed.connect(_on_effect_pressed.bind(fx))
	
	self.offset = color_drawer_offset
	$Effects.offset = fx_drawer_offset


func _on_color_button_pressed() -> void:
	if color_tween: color_tween.kill()
	color_tween = create_tween()
	color_tween.set_ease(Tween.EASE_IN_OUT)
	color_tween.set_trans(Tween.TRANS_BACK)
	var final = color_drawer_offset if color_drawer_out else Vector2(
		#halve it because our scale is 0.5
		color_drawer_offset.x - ($Drawer.size.x / 2), color_drawer_offset.y
		)
	color_tween.tween_property(self, "offset", final, 0.5)
	
	color_drawer_out = not color_drawer_out


func _on_effect_button_pressed() -> void:
	if fx_tween: fx_tween.kill()
	fx_tween = create_tween()
	fx_tween.set_ease(Tween.EASE_IN_OUT)
	fx_tween.set_trans(Tween.TRANS_BACK)
	var final = fx_drawer_offset if fx_drawer_out else Vector2(
		#halve it because our scale is 0.5
		fx_drawer_offset.x - ($Effects/Drawer.size.x / 2), fx_drawer_offset.y
		)
	fx_tween.tween_property($Effects, "offset", final, 0.5)
	
	fx_drawer_out = not fx_drawer_out


func _on_ingredient_pressed(index : int) -> void:
	ing_in_hand = item_indexes[index]


func _on_effect_pressed(index : int) -> void:
	fx_in_hand = index


func _on_request_ingredient(requestor: Node2D) -> void:
	if ing_in_hand:
		requestor.ingredient = ing_in_hand
		#requestor.ingredient.ing_name = ing_in_hand.ing_name
		#requestor.ingredient.ing_color = ing_in_hand.ing_color
		ing_in_hand = null
	requestor.ingredient.effect = fx_in_hand


func _flower():
	pass

func _crackle():
	pass

func _brocade():
	pass

func _palm():
	pass
