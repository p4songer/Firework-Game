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
"My grandmother’s favorite flowers were roses. I think sending up some flowers to heaven with a red firework might be a nice end to the funeral",
"It’s our anniversary and I thought my wife might really love a surprise firework display. Choose a passionate color.",# The brocade effect I’ve heard is the biggest. Obviously, I want to show her how huge my love for her is.
"My favorite color is red and it’s my birthday! It’s the big 30! I want to celebrate with all my bros!",
"I need fireworks for the office Christmas party. I prefer red to green. It’s just work so I really don’t care about the type.",
"I’m getting married and we want our send off to be fireworks. Obviously red is the language of love so that would be perfect.",# The palm effect is beautiful which is all we want on our big day.",
"Roses are red. Violets are blue. I am quite in love with you. Here’s a flower as I get down on one knee. Marry me? Can you do a display like that for my proposal?",
"We want to do something non-traditional for our gender reveal. We already know it will be a girl.",# So something cute like flowers would be perfect.",
],
	Color(0.0, 0.0, 1.0, 1.0): [
		"It’s my son’s first birthday. He loves that show about the blue dog that looks for clues.",# I want a big crackling  one for the show",
		"We want to do something non-traditional for our gender reveal. We already know it will be a boy.",# Crazy that the baby isn’t even the size of our palm yet. (baby blue, palm effect)",
		"My son is getting a medal of honor from the navy. We are having a party afterwards. ",# I think a navy blue firework with a brocade effect would be the perfect way to celebrate his achievements.",
		#"We don’t feel like celebrating much this Christmas. It’s our first year without my daughter. We’ve decided to have a remembrance instead. She had beautiful blue eyes. Something simple to end that night feels appropriate",
		"After our vacation we’re moving to the ocean. We want to use fireworks to announce it to our friends. Can you do ocean colors?",#Blue like the ocean and palms like the trees would be perfect",
		],
	Color(0.0, 1.0, 0.0, 1.0): [
"I had this really cool idea for our tree lighting ceremony to send off fireworks once the tree is lit. An Evergreen firework would be amazing!",#palm firework would be great",
"I’m graduating and I really want to celebrate the end of my education with a bang! My school colors were lime green and black.",#It be awesome to have a crackling display",
"We’ve been fundraising to plant a grove of trees in this abandoned area as a part of our Better World non-profit. We finally hit our goal. We want to celebrate!",# with a green palm effect",
"It’s my bachelor party and what is a better way to celebrate the end to singlehood than an explosion. I love like shamrock green to honor my irish roots as I celebrate with the bros.",
"I just published my debut novel. I am so thrilled that I invited all my people over to celebrate. The firework should match the green cover.",# and it feels like a big deal so the brocade effect is the one I want
#"The Sims hit 50 years! Our company is going to have a televised firework display for the fans. Plumbob green with a palm effect is the only way to celebrate
		],
	Color(1.0, 0.4, 0.0, 1.0): [
"It’s my nephew’s first birthday. He loves the Australian show about the blue dog. Oh, but it's not the blue dog, the orange dog in the show is actually his favorite.",
"My daughter begged me for fireworks for her 12th birthday. I don’t really know much about fireworks, but her favorite color is orange",
"We need fireworks for the Olympics when the winner is announced. Give me a gold firework",
"We just had a merger with another big company and are changing our logo to include orange. It’s the primary color in their logo. We’d like a firework to represent the handshake that hopefully secured our future.",
"I’m turning eighteen and I’m having a spooky party. What better firework color than orange.",
],
	Color(0.7, 0.0, 0.7, 1.0): [
"My mom has always been my biggest cheerleader. I want to do something extra special to thank her for being my mom and give her flowers for all her hard work. Her favorite color is purple.",
"My bridal shower is going to be in the evening. I love the final thought being a shower of love with fireworks. All the decor was purple.",
"My best friend’s husband is proposing and he asked me to coordinate the surprise engagement party. She’s literally the best and her favorite color is purple.",
"My grandpa is going to turn one hundred. Big deal. His favorite color is purple.",
"I love that anime about pop stars fighting demons. I know I’m too old for it but I can’t help it. I want to have an extra special girls night watch party. I would love a purple that matches the star's hair.",
],
	Color(1.0, 1.0, 1.0, 1.0): [
"I hear wedding bells. My grandson is bringing his girlfriend over to meet us. Maybe some white fireworks so I can get through his thick skull.",
"Where we used to live there was snow every Christmas. Now that we’ve moved for my job where it doesn’t, my kids are bummed. I want to make our own snow with a flower effect.",
"My sister passed away unexpectedly. The family really loves the idea of an eternal angel theme because she was like that.",
"My son just got second place in his karate competition. He knows it’s still good but he’s kicking himself that it’s not first. I want to show him to celebrate accomplishments no matter what.",
"I’m opening my own bakery. I want to set off fireworks after cutting the opening ribbon. Something to match the frosting maybe?",
],
}

func build_random() -> void:
	npc_name = _name_array.pick_random()
	fav_color = _color_array.pick_random()
	fav_effect = _effect_array.pick_random()
	
	npc_request = _color_statements[fav_color].pick_random()
	npc_request += [
		" for the effect, I was thinking maybe... %s", " I've always liked the %s effect",
		" %s should be fine.", " Oooh, how about %s?"
	].pick_random() % fav_effect


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
