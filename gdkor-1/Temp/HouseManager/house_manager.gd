extends Node2D

#TODO Money should be a global var that is updated with cost and customer payments.
#TODO Make StarMinigame, CraftStars, and AssembleFirework an interchangable stack

@onready var auction_house: Node2D = $AuctionHouse
@onready var create_stars: Node2D = $CreateStars
@onready var star_minigame: Node2D = $StarMinigame
@onready var launch: Node2D = $LaunchScene
@onready var customers: HBoxContainer = $CustomerUI/TabContainer/Customers
@onready var reviews: GridContainer = $CustomerUI/TabContainer/Reviews/GridContainer


var customer_array : Array
var transition_tween : Tween
var ui_tween : Tween

var ingredient = IngredientResource.new()

var room_index : int = 0

const QTE_ITEM = preload("uid://l2s6ioimdxc")

func _ready() -> void:
	EventBus.qte_clicked.connect(_on_qte_click)
	EventBus.room_completed.connect(_on_room_complete)
	
	auction_house.active = true
	$FocusCam.enabled = false
	#_ui_hide()


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
			$CraftStars.toggle_camera(true)
			$FocusCam.enabled = false
		2:
			ingredient.ing_color = $CraftStars.final_color
			$CraftStars.toggle_camera(false)
			$FocusCam.enabled = true
			tween_cam()
		
		3:
			# if next room is launch
			ingredient.effect = $StarMinigame.selection_index
			tween_cam(launch.get_launch_pos())
			launch.ingredient = ingredient
		4:
			# if prev room was launch:
			var review = _get_customer_review()
		_:
			tween_cam()


func _ui_view() -> void:
	if ui_tween: ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 0), 0.3)
	#ui_tween.tween_property($CustomerUI/Hbox, "scale", Vector2.ONE, 0.3)


func _ui_hide() -> void:
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
	var cus : NPC_Resource = customers.get_child(0).npc_data
	print(cus.npc_name, " likes the color ", cus.fav_color, " with ", cus.fav_effect)
	
	return false
