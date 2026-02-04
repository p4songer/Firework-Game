extends Node2D

@onready var auction_house: Node2D = $AuctionHouse
@onready var create_stars: Node2D = $CreateStars
@onready var star_minigame: Node2D = $StarMinigame

var customer_array : Array
var active_tween : Tween

var ingredient = IngredientResource.new()

func _ready() -> void:
	EventBus.qte_clicked.connect(_on_qte_click)
	EventBus.room_completed.connect(_on_room_complete)
	
	auction_house.active = true
	$FocusCam.enabled = false


func _on_qte_click(npc : NPC_Resource) -> void:
	customer_array.append(npc)
	if customer_array.size() == 1:
		auction_house.active = false
		$FocusCam.enabled = true
		tween_cam()


func tween_cam() -> void:
	if active_tween:
		active_tween.kill()
	active_tween = create_tween()
	active_tween.tween_property(
		$FocusCam, "position", $FocusCam.position + Vector2(1920, 0), 1.0
		)


func _on_room_complete() -> void:
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
