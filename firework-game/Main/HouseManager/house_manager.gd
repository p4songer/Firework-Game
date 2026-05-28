extends Node2D

#TODO Create economy for buying ingredients, and selling fireworks.
@onready var launch: Node2D = $NewLaunch
@onready var auction_house: Node2D = $AuctionHouse
@onready var customers: GridContainer = $CustomerUI/TabContainer/Customers
@onready var reviews: GridContainer = $CustomerUI/TabContainer/Reviews
@onready var customer_detail: Control = $CustomerUI/CustomerDetail
@onready var cash_display: Label = $CustomerUI/Cash

var ui_active: bool = true:
	set(new):
		ui_active = new
		$CustomerUI.visible = ui_active
var customer_array: Array[NPC_Resource] = []
var transition_tween: Tween
var ui_tween: Tween

var room_index: int = 0

var fireworks: Array[FireworkResource] = []
var _pending_color_cost: float = 0.0
var _pending_effect_cost: float = 0.0

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
	#gets the firework resource when assembly is complete.
	EventBus.firework_assembled.connect(_on_firework_assembled)
	#triggers start of firework display
	EventBus.display_started.connect(_on_display_started)

	auction_house.spawn_lineup(5)

	# TODO Revisit and delete from global. House manager should hold customers and reviews.
	if not Global.review_array.is_empty():
		$CustomerUI/TabContainer.set_tab_hidden(1, false)
		for npc: NPC_Resource in Global.review_array:
			var new_review: Node = REVIEW.instantiate()
			new_review.data = npc
			reviews.add_child(new_review)
	
	# TODO Temp effects 
	for eff in IngredientResource.EFFECTS:
		Economy.add_effect(eff, {"effect": eff, "cost": 2.0, "is_dud": true})
		
	#TODO Temp colors in economy 
	Economy.add_color("CrimsonBurst", {"color": Color8(220, 20, 60), "cost": 3.0})
	Economy.add_color("OceanBlue", {"color": Color8(30, 144, 255), "cost": 4.29})
	Economy.add_color("Sunflare", {"color": Color8(255, 180, 25), "cost": 4.60})

	#TODO Temp starting money
	Economy.set_money(100.0)
	cash_display.text = "Cash: $" + str(Economy.get_money())


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
	# TODO Revisit and delete from global. Refactor customer interactions.
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
	EventBus.room_changed.emit()
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
## color_cost: The cost of crafting the color based on grain count.
func _on_craft_stars_completed(final_color: Color, color_cost: float) -> void:
	_pending_color_cost = color_cost
	Economy.add_color("CustomBlend", {"color": final_color, "cost": color_cost})


func _on_star_minigame_completed(effect: IngredientResource.EFFECTS, success: bool, effect_cost: float) -> void:
	_pending_effect_cost = effect_cost
	_validate_affordability()
	var effect_string : String = IngredientResource.translate(effect)
	Economy.add_effect(effect_string, {"effect": effect, "cost":effect_cost, "success": success})


func _validate_affordability() -> void:
	var total_cost: float = _pending_color_cost + _pending_effect_cost
	# TODO: Expand with actual wallet implementation
	_pending_color_cost = 0.0
	_pending_effect_cost = 0.0


func _on_firework_assembled(firework_resource: FireworkResource) -> void:
	print_debug("ASSEMBLED")
	fireworks.append(firework_resource)
	Economy.set_money(Economy.get_money() - firework_resource.get_total_cost())
	cash_display.text = "Cash: $" + str(Economy.get_money())


func _on_display_started() -> void:
	print_debug("START DISPLAY")
	print(fireworks)
	launch.set_active(fireworks)
	$FocusCam.enabled = false

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
