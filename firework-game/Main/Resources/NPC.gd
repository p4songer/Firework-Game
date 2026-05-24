class_name NPC_Resource extends Resource

@export var npc_name: String = ""
@export var fav_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var fav_effect: String = ""
@export var npc_request: String = ""
@export var npc_sprite: CompressedTexture2D

## Runtime notepad entries for this NPC. Each entry is a Dictionary with keys:
## "id" (String), "timestamp" (int), "author" (String), "content" (String),
## "type" (String: "player_note" or "auto_review"), "rating" (int),
## "score" (float), "flags" (Array[Dictionary]), "hint_key" (String).
@export var notepad_entries: Array = []

## Retained for external compatibility. Populated by generate_and_append_review.
var given_review: String = ""
var dud_firework: bool = false

const _color_array: Array[Color] = [
const _color_array: Array[Color] = [
	Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 0.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0), Color(0.7, 0.0, 0.7, 1.0), Color(1.0, 0.4, 0.0, 1.0)
]
const _color_translator: Dictionary = {
	Color(1.0, 0.0, 0.0, 1.0): "red",
	Color(0.0, 0.0, 1.0, 1.0): "blue",
	Color(0.0, 1.0, 0.0, 1.0): "green",
	Color(1.0, 1.0, 1.0, 1.0): "white",
	Color(0.7, 0.0, 0.7, 1.0): "purple",
	Color(1.0, 0.4, 0.0, 1.0): "orange",
}

const _effect_array: Array[String] = [
	"crackle", "default", "brocade", "palm",
]
const _name_array: Array[String] = [
	"Alice", "Benim", "Crude Forge", "Dugong", "Evengy", "Frederick", "Guntah", "Henry",
	"Scarlet", "Jamie", "Katherine", "Loten", "Mooshroom", "Moonfall", "Olivia", "Paintsimmon",
	"Quentin", "Spoonsweet", "Sqlpy", "Phrog", "Urbandrei", "Victoria", "William", "Xander",
	"Yolo", "Hermes",
]
#TODO Use a spreadsheet for these statements.
const _color_statements: Dictionary = {
	Color(1.0, 0.0, 0.0, 1.0): [
		"My grandmother's favorite flowers were roses. I think sending up some flowers to heaven with a red firework might be a nice end to the funeral",
		"It's our anniversary and I thought my wife might really love a surprise firework display. Choose a passionate color.",
		"My favorite color is red and it's my birthday! It's the big 30! I want to celebrate with all my bros!",
		"I need fireworks for the office Christmas party. I prefer red to green. It's just work so I really don't care about the type.",
		"I'm getting married and we want our send off to be fireworks. Obviously red is the language of love so that would be perfect.",
		"Roses are red. Violets are blue. I am quite in love with you. Here's a flower as I get down on one knee. Marry me? Can you do a display like that for my proposal?",
		"We want to do something non-traditional for our gender reveal. We already know it will be a girl.",
	],
	Color(0.0, 0.0, 1.0, 1.0): [
		"It's my son's first birthday. He loves that show about the blue dog that looks for clues.",
		"We want to do something non-traditional for our gender reveal. We already know it will be a boy.",
		"My son is getting a medal of honor from the navy. We are having a party afterwards.",
		"After our vacation we're moving to the ocean. We want to use fireworks to announce it to our friends. Can you do ocean colors?",
	],
	Color(0.0, 1.0, 0.0, 1.0): [
		"I had this really cool idea for our tree lighting ceremony to send off fireworks once the tree is lit. An Evergreen firework would be amazing!",
		"I'm graduating and I really want to celebrate the end of my education with a bang! My school colors were lime green and black.",
		"We've been fundraising to plant a grove of trees in this abandoned area as a part of our Better World non-profit. We finally hit our goal. We want to celebrate!",
		"It's my bachelor party and what is a better way to celebrate the end to singlehood than an explosion. I love like shamrock green to honor my irish roots as I celebrate with the bros.",
		"I just published my debut novel. I am so thrilled that I invited all my people over to celebrate. The firework should match the green cover.",
	],
	Color(1.0, 0.4, 0.0, 1.0): [
		"It's my nephew's first birthday. He loves the Australian show about the blue dog. Oh, but it's not the blue dog, the orange dog in the show is actually his favorite.",
		"My daughter begged me for fireworks for her 12th birthday. I don't really know much about fireworks, but her favorite color is orange",
		"We need fireworks for the Olympics when the winner is announced. Give me a gold firework",
		"We just had a merger with another big company and are changing our logo to include orange. It's the primary color in their logo. We'd like a firework to represent the handshake that hopefully secured our future.",
		"I'm turning eighteen and I'm having a spooky party. What better firework color than orange.",
	],
	Color(0.7, 0.0, 0.7, 1.0): [
		"My mom has always been my biggest cheerleader. I want to do something extra special to thank her for being my mom and give her flowers for all her hard work. Her favorite color is purple.",
		"My bridal shower is going to be in the evening. I love the final thought being a shower of love with fireworks. All the decor was purple.",
		"My best friend's husband is proposing and he asked me to coordinate the surprise engagement party. She's literally the best and her favorite color is purple.",
		"My grandpa is going to turn one hundred. Big deal. His favorite color is purple.",
		"I love that anime about pop stars fighting demons. I know I'm too old for it but I can't help it. I want to have an extra special girls night watch party. I would love a purple that matches the star's hair.",
	],
	Color(1.0, 1.0, 1.0, 1.0): [
		"I hear wedding bells. My grandson is bringing his girlfriend over to meet us. Maybe some white fireworks so I can get through his thick skull.",
		"Where we used to live there was snow every Christmas. Now that we've moved for my job where it doesn't, my kids are bummed. I want to make our own snow with a flower effect.",
		"My sister passed away unexpectedly. The family really loves the idea of an eternal angel theme because she was like that.",
		"My son just got second place in his karate competition. He knows it's still good but he's kicking himself that it's not first. I want to show him to celebrate accomplishments no matter what.",
		"I'm opening my own bakery. I want to set off fireworks after cutting the opening ribbon. Something to match the frosting maybe?",
	],
}
const bad_color: Array[String] = [
	"Ummm, I don't know if that was the %s I was looking for. Did it explode correctly?",
	"Hello? I said %s. What was that?",
	"I'm sorry.... is the color I asked for puke? That's definitely not %s.",
	"I could pretend I like that color %s. I'd be lying.",
	"I think you're colorblind. Have you ever seen the color %s before?"
]
const okay_color: Array[String] = [
	"Oh, that was pretty. Really nice. I wish you had listened a little better to get closer to the %s I wanted.",
	"It definitely fit the function even though it wasn't quite what I wanted. The %s was cute but I wish it had been brighter",
	"My friends and family really loved that. I'm not sure the %s was exactly what I wanted but decent job.",
	"That %s feels adjacent to what I asked for.",
]
const good_color: Array[String] = [
	"That was 10/10 amazing! I feel like you captured exactly the %s I wanted.",
	"Did I just fall in love with a firework? I think so. That %s was speaking the language of my heart. The vibrant %s gave the exact energy I needed.",
	"That ate and left no crumbs. Literally, the best %s.",
	"Totally tubular dude. That %s was.. Wow."
]
const bad_effect: Array[String] = [
	"Oh that was pretty. Really nice. I wish you had listened a little better for the effect I was hoping for.",
	"Too small. Not what I wanted for the effect, won't buy again.",
	"It did the job. I received a colorful firework with an effect. That's technically what I asked for.",
	"Did a five year old make this effect though?",
]
const good_effect: Array[String] = [
	" You don't even understand how perfect that effect was.",
	" The effect is just as beautiful as I thought.",
	" My kid said, \"That was amazing!\" Good job!",
	" I'm so over the moon! You have no idea how much that checked all my boxes! It's rare to have someone meet my expectations on effects.",
	" This firework changed my life. CHANGED MY LIIIIFFFFEEE",
	" I cried. Seeing this firework healed me a little bit."
]
const bad_mix: Array[String] = [
	" I paid for something that felt like it could be made in my backyard. At least this way I didn't have to build it myself. Thanks for saving time with a decent firework.",
	" I should mention that the firework was falling apart. I'm surprised it didn't kill someone.",
	" This feels like the idea of a firework more than a legit firework.",
	" You did a thing. That thing did a thing. That's what matters. Thanks for a good effort.",
]

## Scoring weights for review generation. Must sum to 1.0.
const REVIEW_WEIGHT_COLOR: float = 0.60
const REVIEW_WEIGHT_EFFECT: float = 0.30
const REVIEW_WEIGHT_PRICE: float = 0.10

## Maximum possible RGB distance between two colors, used for normalization.
const MAX_COLOR_DIST: float = 1.732

## Populates this NPC_Resource with randomized data drawn from the internal name, color,
## and effect pools. Also generates a randomized npc_request string.
func build_random() -> void:
	npc_name = _name_array.pick_random()
	# faReturns a normalized color match score in the range 0.0 to 1.0.
## A score of 1.0 indicates a perfect color match. Uses Color.distance_to normalized
## by the maximum possible RGB distance.
## ing_color: The color of the launched firework ingredient.
## target_color: The NPC's preferred color.
func _color_score(ing_color: Color, target_color: Color) -> float:
	var dr: float = ing_color.r - target_color.r
	var dg: float = ing_color.g - target_color.g
	var db: float = ing_color.b - target_color.b
	var dist: float = sqrt(dr * dr + dg * dg + db * db)
	return 1.0 - clamp(dist / MAX_COLOR_DIST, 0.0, 1.0)

## Maps a weighted aggregate score to a 1 to 5 star rating.
## score: The aggregate review score.
func _map_score_to_rating(score: float) -> int:
	if score >= 0.75:
		return 5
	elif score >= 0.50:
		return 4
	elif score >= 0.25:
		return 3
	elif score >= 0.0:
		return 2
	return 1

## Generates a review for the given ingredient, appends it to notepad_entries,
## and emits EventBus.notebook_updated. Uses weighted scoring across color match,
## effect match, and price to select flavor text pools and build structured entry data.
## ingredient: The IngredientResource representing the launched firework.
## observed_price: The price the player charged for this firework.
## expected_price: The baseline price for this firework. Defaults to 0.0 (price contribution neutral).
## price_tolerance: Multiplier threshold before a price penalty is applied. Defaults to 1.0.
func generate_and_append_review(ingredient: IngredientResource, observed_price: float, expected_price: float = 0.0, price_tolerance: float = 1.0) -> void:
	var color_score: float = _color_score(ingredient.ing_color, fav_color)
	var effect_match: bool = _effect_array[ingredient.effect] == self.fav_effect

	var price_score: float = 1.0
	if expected_price > 0.0:
		price_score = clamp(1.0 - (observed_price - expected_price) / max(expected_price, 1.0), 0.0, 1.0)

	var score: float = (REVIEW_WEIGHT_COLOR * color_score) + (REVIEW_WEIGHT_EFFECT * (1.0 if effect_match else 0.0)) + (REVIEW_WEIGHT_PRICE * price_score)

	var flags: Array[Dictionary] = []
	if color_score < 0.7:
		var color_severity: String = "major" if color_score < 0.4 else "minor"
		flags.append({"type": "color_mismatch", "severity": color_severity, "value": color_score})
	if not effect_match:
		flags.append({"type": "effect_mismatch", "severity": "major"})
	if expected_price > 0.0 and observed_price > expected_price * price_tolerance:
		var ratio: float = observed_price / expected_price
		var price_severity: String = "major" if ratio > 1.25 else "minor"
		flags.append({"type": "price_mismatch", "severity": price_severity, "value": ratio})

	var hint_key: String = ""
	if not flags.is_empty():
		hint_key = flags[randi() % flags.size()].get("type", "")

	var color_label: String = _color_translator.get(fav_color, "colorful")
	var color_rev: String = ""
	if color_score >= 0.7:
		color_rev = good_color.pick_random() % color_label
	elif color_score >= 0.4:
		color_rev = okay_color.pick_random() % color_label
	else:
		color_rev = bad_color.pick_random() % color_label

	var eff_rev: String = good_effect.pick_random() if effect_match else bad_effect.pick_random()

	var content: String = color_rev + eff_rev
	if dud_firework:
		content += bad_mix.pick_random()

	given_review = content

	var entry: Dictionary = {
		"id": str(Time.get_unix_time_from_system()) + "_" + str(randi()),
		"timestamp": int(Time.get_unix_time_from_system()),
		"author": "System",
		"content": content,
		"type": "auto_review",
		"rating": _map_score_to_rating(score),
		"firework_name": ingredient.ing_name,
		"flags": flags,
		"hint_key": hint_key,
		"score": score
	}
	notepad_entries.append(entry)
	EventBus.notebook_updated.emit(self)

## Appends a player-authored note to this NPC's notepad_entries array.
## content: The text the player has written.
## author: Display name for the note author. Defaults to "Player".
func add_player_note(content: String, author: String = "Player") -> void:
	var note_entry: Dictionary = {
		"id": str(Time.get_unix_time_from_system()) + "_" + str(randi()),
		"timestamp": int(Time.get_unix_time_from_system()),
		"author": author,
		"content": content,
		"type": "player_note"
	}
	notepad_entries.append(note_entry)
	EventBus.notebook_updated.emit(self)

## Appends an auto-generated review to notepad_entries using a pre-built review string.
## Retained for external callers. New internal code should use generate_and_append_review.
## review_text: The review string to store.
## rating: An optional integer score accompanying the review.
func add_auto_review(review_text: String, rating: int = 0) -> void:
	var review_entry: Dictionary = {
		"id": str(Time.get_unix_time_from_system()) + "_" + str(randi()),
		"timestamp": int(Time.get_unix_time_from_system()),
		"author": "System",
		"content": review_text,
		"type": "auto_review",
		"rating": rating
	}
	notepad_entries.append(review_entry)
	EventBus.notebook_updated.emit(self)
