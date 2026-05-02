extends Node2D

#TODO Create economy for buying ingredients, and selling fireworks.

@onready var auction_house: Node2D = $AuctionHouse
@onready var craft_stars: Node2D = $CraftStars
@onready var star_minigame: Node2D = $StarMinigame
@onready var launch: Node2D = $LaunchScene
@onready var customers: GridContainer = $CustomerUI/TabContainer/Customers
@onready var reviews: GridContainer = $CustomerUI/TabContainer/Reviews
@onready var customer_detail: Control = $CustomerUI/CustomerDetail

var ui_active: bool = true:
	set(new):
		ui_active = new
		$CustomerUI.visible = ui_active
var customer_array: Array[NPC_Resource] = []
var transition_tween: Tween
var ui_tween: Tween

var room_index: int = 0

#TODO Put this in IngredientResource or something. Maybe not a dictionary, maybe just a function that translates the enum to a string.
var effect_translator: Dictionary = {
	IngredientResource.EFFECTS.FLOWER: "default",
	IngredientResource.EFFECTS.CRACKLE: "crackle",
	IngredientResource.EFFECTS.BROCADE: "brocade",
	IngredientResource.EFFECTS.PALM: "palm"
}

const QTE_ITEM: PackedScene = preload("uid://l2s6ioimdxc")
const REVIEW: PackedScene = preload("uid://drq4tuq8bw3k6")

func _ready() -> void:
	#gets the npc clicked to global
	EventBus.qte_clicked.connect(_on_qte_click)
	#unsure what this does, but probably for customer UI
	EventBus.customer_selected.connect(_on_customer_selected)
	#gets color to global color mix registry.
	EventBus.craft_stars_completed.connect(_on_craft_stars_completed)
	#gets effect from star minigame to global effect registry.
	EventBus.star_minigame_completed.connect(_on_star_minigame_completed)

	auction_house.spawn_lineup(5)

	if not Global.review_array.is_empty():
		$CustomerUI/TabContainer.set_tab_hidden(1, false)
		for npc: NPC_Resource in Global.review_array:
			var new_review: Node = REVIEW.instantiate()
			new_review.data = npc
			reviews.add_child(new_review)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		var direction: int = -1 if event.is_action_pressed("ui_left") else 1
		tween_cam(direction)
	#TODO Make the workstation visible on up/down. Maybe notebook also?


## Handles a customer accepting a QTE. Adds the NPC to the active customer list
## and instantiates a display card in the UI. Triggers camera transition on first
## customer collected.
## npc: The NPC_Resource of the customer who clicked the QTE.
func _on_qte_click(npc: NPC_Resource) -> void:
	customer_array.append(npc)
	Global.review_array.append(npc)

	var new_cust: Node = QTE_ITEM.instantiate()
	new_cust.npc_data = npc
	new_cust.display_info = true
	new_cust.active = false
	customers.add_child(new_cust)
	new_cust.scale = Vector2(0.5, 0.5)
	customers.pivot_offset = customers.size / 2

	if customer_array.size() == 1:
		tween_cam()


## Tweens the focus camera to a new position. If no destination is provided, advances
## one screen width to the right. Awaitable.
## destination: Optional target position for the camera. Defaults to null.
func tween_cam(destination: int = 1) -> void:
	if transition_tween:
		transition_tween.kill()
	transition_tween = create_tween()
	var new_pos : Vector2 = Vector2(snapped($FocusCam.position.x, 1920) + 1920 * destination, 0)
	new_pos = new_pos.clamp(Vector2(0, 0), Vector2(1920* 4, 0))
	transition_tween.tween_property($FocusCam, "position", new_pos, 1.0)
	transition_tween.finished.connect(_transition_finished)
	await transition_tween.finished


## Receives the final crafted color from craft_stars adds it to the color mix registry in Global.
## final_color: The blended color computed by the craft_stars scene.
func _on_craft_stars_completed(final_color: Color) -> void:
	Global.add_mix("CustomBlend", 15.0, final_color)


func _on_star_minigame_completed(effect_index: int, success: bool) -> void:
	Global.add_effect(effect_index, success)

# FIXME THIS SHOULD BE A DEAD FUNCTION. ENSURE ALL ROOMS WORK INDEPENDENTLY WITHOUT THIS. 
# func _on_room_complete(payload: Variant) -> void:
# 	print(payload)
# 	room_index += 1
# 	match room_index:
# 		1:
# 			await tween_cam()
# 			# craft_stars.toggle_camera(true)
# 		2:
# 			tween_cam()
# 		3:
# 			ingredient.effect = star_minigame.selection_index
# 			tween_cam(launch.get_launch_pos())
# 			launch.ingredient = ingredient
# 		4:
# 			_generate_customer_review()
# 		_:
# 			tween_cam()


## Generates a structured review for the most recently active customer using the assembled
## ingredient, appends it to the NPC's notepad, and instantiates a Review UI node.
func _generate_customer_review() -> void:
	if customer_array.is_empty():
		return
	var customer: NPC_Resource = customer_array[-1]
	# customer.generate_and_append_review(ingredient, 0.0) TODO Refactor ingredient logic
	var new_review: Node = REVIEW.instantiate()
	new_review.data = customer
	reviews.add_child(new_review)
	$CustomerUI/TabContainer.set_tab_hidden(1, false)


## Opens the CustomerDetail panel for the selected NPC.
## npc: The NPC_Resource to display in the detail view.
func _on_customer_selected(npc: NPC_Resource) -> void:
	customer_detail.load_npc(npc)
	customer_detail.visible = true


func _ui_view() -> void:
	if ui_tween:
		ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 0), 0.3)


func _ui_hide() -> void:
	$CustomerUI/TabContainer.current_tab = 0
	if ui_tween:
		ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 250), 0.3)


func _transition_finished() -> void:
	if room_index == 3:
		launch.make_active()
		$FocusCam.enabled = false


func _on_ui_mouse_entered() -> void:
	_ui_view()


func _on_ui_mouse_exited() -> void:
	_ui_hide()


func _on_tab_hovered(_tab: int) -> void:
	_ui_view()


func _on_star_minigame_start_game() -> void:
	ui_active = false
