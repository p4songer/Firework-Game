extends CanvasLayer

@export var drawer_offset : Vector2
var drawer_out : bool = false
var active_tween : Tween

var item_indexes : Dictionary = {}

var ing_in_hand : IngredientResource = null

func _ready() -> void:
	EventBus.request_ingredient.connect(_on_request_ingredient)
	
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
	self.offset = drawer_offset


func _on_texture_button_pressed() -> void:
	if active_tween: active_tween.kill()
	active_tween = create_tween()
	active_tween.set_ease(Tween.EASE_IN_OUT)
	active_tween.set_trans(Tween.TRANS_BACK)
	var final = drawer_offset if drawer_out else Vector2(
		#halve it because our scale is 0.5
		drawer_offset.x - ($Drawer.size.x / 2), drawer_offset.y
		)
	active_tween.tween_property(self, "offset", final, 0.5)
	
	drawer_out = not drawer_out


func _on_ingredient_pressed(index : int) -> void:
	ing_in_hand = item_indexes[index]


func _on_request_ingredient(requestor: Node2D) -> void:
	requestor.new_ing = ing_in_hand
	ing_in_hand = null
