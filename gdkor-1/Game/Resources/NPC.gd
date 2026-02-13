class_name NPC_Resource extends Resource

#TODO Notepad for customer preferences.
@export var npc_name : String
@export var fav_color : Color
@export var fav_effect : String
@export var npc_request : String
@export var npc_sprite : CompressedTexture2D

var given_review : String
var dud_firework : bool = false

const _color_array : Array = [
	Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 0.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0), Color(0.7, 0.0, 0.7, 1.0), Color(1.0, 0.4, 0.0, 1.0)
]

const _effect_array : Array = [
	"crackle", "default", "brocade", "palm",
]
const _name_array : Array = [
	"Alice", "Benim", "Crude Forge", "Dugong", "Evengy", " Frederick", "Guntah", "Henry",
	"Scarlet", "Jamie", "Katherine", "Loten", "Mooshroom", "Moonfall", "Olivia", "Paintsimmon",
	"Quentin", "Spoonsweet", "Sqlpy", "Phrog", "Urbandrei", "Victoria", "William", "Xander",
	"Yolo", "Hermes",
]
#TODO Use a spreadsheet for these statements.
const _color_statements : Dictionary = {
	Color(1.0, 0.0, 0.0, 1.0): [
		"I like red fireworks", 
		"My grandmother's favorite flower was a rose. Due to her recent passing, I want to
		remember her with a firework display."
		],
	Color(0.0, 0.0, 1.0, 1.0): [
		"I like blue fireworks",
		"After our vacation to the ocean, we've decided to live by the beach. 
		We want to annouce our move to our family through a firework display."
		],
	Color(0.0, 1.0, 0.0, 1.0): [
		"I like green fireworks",
		"My girlfriend's eyes are the most beautiful shade of green I've seen.
		She means the world to me, and I can't wait to propose to her. ",
		],
	Color(1.0, 0.4, 0.0, 1.0): ["I like orange fireworks"],
	Color(0.7, 0.0, 0.7, 1.0): ["I like purple fireworks"],
	Color(1.0, 1.0, 1.0, 1.0): ["I like white fireworks"],
}

func build_random() -> void:
	npc_name = _name_array.pick_random()
	fav_color = _color_array.pick_random()
	fav_effect = _effect_array.pick_random()
	
	npc_request = _color_statements[fav_color][0] + " with the %s effect."% fav_effect


func get_review(given_firework: IngredientResource) -> void:
	#FIXME Super temporary.
	var color_threshold = 0.25
	var fail_threshold = 0.35
	
	var color_dif = self.fav_color - given_firework.ing_color
	var color_good_enough : int = 6 if not given_firework.ing_color.is_equal_approx(Color()) else 0
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
	var color_rev = ""
	print(color_good_enough)
	if color_good_enough >= 4:
		color_rev = "The color was perfect!"
	elif color_good_enough > 2:
		color_rev = "The color was good, but could have been better."
	else:
		color_rev = "That was the wrong color."
	
	var eff_rev = " And the effect was amazing!" if _effect_array[
		given_firework.effect] == self.fav_effect else " And the effect was okay, but not what I asked for."
	
	given_review = color_rev + eff_rev
	if dud_firework:
		given_review += "Not to mention that the firework was falling apart. I'm surprised it didn't kill someone."
