extends Node2D

@onready var auction_house: Node2D = $AuctionHouse
@onready var create_stars: Node2D = $CreateStars
@onready var star_minigame: Node2D = $StarMinigame
@onready var launch: Node2D = $LaunchScene

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


func _on_qte_click(npc : NPC_Resource) -> void:
	customer_array.append(npc)
	
	var new_cust = QTE_ITEM.instantiate()
	new_cust.npc_data = npc
	new_cust.display_info = true
	$CustomerUI/Hbox.add_child(new_cust)
	new_cust.scale = Vector2(0.5, 0.5)
	new_cust.hovered.connect(_ui_view)
	new_cust.unhovered.connect(_ui_hide)
	$CustomerUI/Hbox.pivot_offset = $CustomerUI/Hbox.size / 2
	
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


func _on_room_complete() -> void:
	room_index += 1
	match room_index:
		2:
			# if next room is star creator
			ingredient.effect = $CreateStars.final_effect
			ingredient.ing_color = $CreateStars.final_color
			match ingredient.effect:
				0:
					$StarMinigame.current_build = "default"
				1:
					$StarMinigame.current_build = "crackle"
				2:
					$StarMinigame.current_build = "brocade"
				3:
					$StarMinigame.current_build = "palm"
			
			#FIXME This is broke
			#TODO Fix this thing
			$StarMinigame._parse_build()
			tween_cam()
		
		3:
			# if next room is launch
			tween_cam(launch.get_launch_pos())
			launch.ingredient = ingredient
		
		_:
			tween_cam()


func _ui_view() -> void:
	if ui_tween: ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 0), 0.3)
	ui_tween.tween_property($CustomerUI/Hbox, "scale", Vector2.ONE, 0.3)


func _ui_hide() -> void:
	if ui_tween: ui_tween.kill()
	ui_tween = create_tween().set_parallel(true)
	ui_tween.tween_property($CustomerUI, "offset", Vector2(0, 200), 0.3)
	ui_tween.tween_property($CustomerUI/Hbox, "scale", Vector2(0.5, 0.5), 0.3)


func _transition_finished() -> void:
	if room_index == 3:
		launch.make_active()
		$FocusCam.enabled = false
