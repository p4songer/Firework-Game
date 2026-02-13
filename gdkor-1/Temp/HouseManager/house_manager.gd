extends Node2D

#TODO Money should be a global var that is updated with cost and customer payments.
#TODO Make StarMinigame, CraftStars, and AssembleFirework an interchangable stack

@onready var auction_house: Node2D = $AuctionHouse
@onready var craft_stars: Node2D = $CraftStars
@onready var star_minigame: Node2D = $StarMinigame
@onready var launch: Node2D = $LaunchScene
@onready var customers: GridContainer = $CustomerUI/TabContainer/Customers
@onready var reviews: GridContainer = $CustomerUI/TabContainer/Reviews

var ui_active : bool = true:
	set(new):
		ui_active = new
		$CustomerUI.visible = ui_active
var customer_array : Array
var transition_tween : Tween
var ui_tween : Tween

var ingredient = IngredientResource.new()

var room_index : int = 0

var effect_translator : Dictionary = {
	IngredientResource.EFFECTS.FLOWER : "default", 
	IngredientResource.EFFECTS.CRACKLE : "crackle",
	IngredientResource.EFFECTS.BROCADE : "brocade",
	IngredientResource.EFFECTS.PALM : "palm"
}

const QTE_ITEM = preload("uid://l2s6ioimdxc")
const REVIEW = preload("uid://drq4tuq8bw3k6")

func _ready() -> void:
	print("loaded")
	EventBus.qte_clicked.connect(_on_qte_click)
	EventBus.room_completed.connect(_on_room_complete)
	
	auction_house.active = true
	$FocusCam.enabled = false
	
	if not Global.review_array.is_empty():
		$CustomerUI/TabContainer.set_tab_hidden(1, false)
		for rev in Global.review_array:
			reviews.add_child(rev)


func _on_qte_click(npc : NPC_Resource) -> void:
	customer_array.append(npc)
	
	var new_cust = QTE_ITEM.instantiate()
	new_cust.npc_data = npc
	new_cust.display_info = true
	new_cust.active = false
	customers.add_child(new_cust)
	new_cust.scale = Vector2(0.5, 0.5)
	#new_cust.hovered.connect(_ui_view)
	#new_cust.unhovered.connect(_ui_hide)
	customers.pivot_offset = customers.size / 2
	
	# if auction house complete
	if customer_array.size() == 1:
		auction_house.clear_house()
		auction_house.active = false
		$FocusCam.enabled = true
		tween_cam()


func tween_cam(destination = null) -> void:
	if transition_tween:
		transition_tween.kill()
	transition_tween = create_tween()
	var new_pos = destination if destination else $FocusCam.position + Vector2(1920, 0)
	transition_tween.tween_property($FocusCam, "position", new_pos, 1.0)
	transition_tween.finished.connect(_transition_finished)
	await transition_tween.finished
	return


func _on_room_complete() -> void:
	room_index += 1
	match room_index:
		1:
			#await get_tree().create_timer(1.0).timeout
			await tween_cam()
			craft_stars.toggle_camera(true)
			$FocusCam.enabled = false
		2:
			ingredient.ing_color = craft_stars.final_color
			craft_stars.toggle_camera(false)
			$FocusCam.enabled = true
			tween_cam()
		
		3:
			# if next room is launch
			ingredient.effect = star_minigame.selection_index
			tween_cam(launch.get_launch_pos())
			launch.ingredient = ingredient
		4:
			# if prev room was launch:
			var review_string = _get_customer_review()
			var new_rev = REVIEW.instantiate()
			new_rev.text_data = review_string
			Global.review_array.append(new_rev)
			print("added to array")
		_:
			tween_cam()


func _ui_view() -> void:	
	if ui_tween: ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 0), 0.3)
	#ui_tween.tween_property($CustomerUI/Hbox, "scale", Vector2.ONE, 0.3)


func _ui_hide() -> void:
	$CustomerUI/TabContainer.current_tab = 0
	if ui_tween: ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 250), 0.3)
	#ui_tween.tween_property($CustomerUI/Hbox, "scale", Vector2(0.5, 0.5), 0.3)


func _transition_finished() -> void:
	if room_index == 3:
		launch.make_active()
		$FocusCam.enabled = false


func _on_ui_mouse_entered() -> void:
	_ui_view()


func _on_ui_mouse_exited() -> void:
	pass
	_ui_hide()


func _on_tab_hovered(_tab: int) -> void:
	_ui_view()


func _get_customer_review() -> Variant:
	#FIXME Super temporary.
	var color_threshold = 0.25
	var fail_threshold = 0.35
	var cus : NPC_Resource = customers.get_child(0).npc_data
	var color_dif = cus.fav_color - ingredient.ing_color
	var color_good_enough : int = 6 if not ingredient.ing_color.is_equal_approx(Color()) else 0
	for i in 3:
		match i:
			0:
				if abs(color_dif.r) > color_threshold:
					color_good_enough -= 1
				if abs(color_dif.r) > fail_threshold:
					color_good_enough -= 1
			1:
				if abs(color_dif.g) > color_threshold:
					color_good_enough -= 1
				if abs(color_dif.g) > fail_threshold:
					color_good_enough -= 1
			2:
				if abs(color_dif.b) > color_threshold:
					color_good_enough -= 1
				if abs(color_dif.b) > fail_threshold:
					color_good_enough -= 1
	print("color good? ", color_good_enough, color_good_enough >= 4)
	print("effecdt good? ", cus.fav_effect == effect_translator[ingredient.effect])
	var color_rev = ""
	if color_good_enough >= 4:
		color_rev = "The color was perfect!"
	elif color_good_enough < 2:
		color_rev = "The color was good, but could have been better."
	else:
		color_rev = "That was the wrong color."
	
	var eff_rev = " And the effect was amazing!" if effect_translator[
		ingredient.effect] == cus.fav_effect else " And the effect was okay, but not what I asked for."
	
	return color_rev + eff_rev


func _on_star_minigame_start_game() -> void:
	ui_active = false
