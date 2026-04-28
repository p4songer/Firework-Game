class_name NPC_Resource extends Resource

@export var npc_name: String = ""
@export var fav_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var fav_effect: String = ""
@export var npc_request: String = ""
@export var npc_sprite: CompressedTexture2D

## Runtime notepad entries for this NPC. Each entry is a Dictionary with keys:
## "id" (String), "timestamp" (int), "author" (String), "content" (String),
## "type" (String: "player_note" or "auto_review"), and optionally "rating" (int).
@export var notepad_entries: Array = []

var given_review: String = ""
var dud_firework: bool = false

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

## Populates this NPC_Resource with randomized data drawn from the internal name, color,
## and effect pools. Also generates a randomized npc_request string.
func build_random() -> void:
	npc_name = _name_array.pick_random()
	fav_color = _color_array.pick_random()
	fav_effect = _effect_array.pick_random()
	npc_request = _color_statements[fav_color].pick_random()
	npc_request += [
		" for the effect, I was thinking maybe... %s", " I've always liked the %s effect",
		" %s should be fine.", " Oooh, how about %s?"
	].pick_random() % fav_effect

## Generates and stores a textual review in given_review based on how closely the provided
## firework matches this NPC's color and effect preferences.
## given_firework: The IngredientResource representing the firework that was launched.
func get_review(given_firework: IngredientResource) -> void:
	#FIXME Super temporary.
	var color_threshold: float = 0.25
	var fail_threshold: float = 0.35

	var color_dif: Color = self.fav_color - given_firework.ing_color
	var color_good_enough: int = 6 if not given_firework.ing_color.is_equal_approx(Color()) else 0
	for i: int in 3:
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

	var color_rev: String = ""
	if color_good_enough >= 4:
		color_rev = good_color.pick_random() % _color_translator[fav_color]
	elif color_good_enough > 2:
		color_rev = okay_color.pick_random() % _color_translator[fav_color]
	else:
		color_rev = bad_color.pick_random() % _color_translator[fav_color]

	var eff_rev: String = good_effect.pick_random() if _effect_array[
		given_firework.effect] == self.fav_effect else bad_effect.pick_random()

	given_review = color_rev + eff_rev
	if dud_firework:
		given_review += bad_mix.pick_random()

## Appends a player-authored note to this NPC's notepad_entries array.
## content: The text the player has written.
## author: Display name for the note author. Defaults to "Player".
func add_player_note(content: String, author: String = "Player") -> void:
	var entry: Dictionary = {
		"id": str(Time.get_unix_time_from_system()) + "_" + str(randi()),
		"timestamp": int(Time.get_unix_time_from_system()),
		"author": author,
		"content": content,
		"type": "player_note"
	}
	notepad_entries.append(entry)
	EventBus.notebook_updated.emit(self)

## Appends an auto-generated review to this NPC's notepad_entries array.
## review_text: The review string produced by get_review.
## rating: An optional integer score accompanying the review.
func add_auto_review(review_text: String, rating: int = 0) -> void:
	var entry: Dictionary = {
		"id": str(Time.get_unix_time_from_system()) + "_" + str(randi()),
		"timestamp": int(Time.get_unix_time_from_system()),
		"author": "System",
		"content": review_text,
		"type": "auto_review",
		"rating": rating
	}
	notepad_entries.append(entry)
	EventBus.notebook_updated.emit(self)
