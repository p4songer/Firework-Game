class_name IngredientResource extends Resource

enum EFFECTS { FLOWER, CRACKLE, BROCADE, PALM }

# Maps lowercase storage strings to true Enum values
const KEY_MAP = {
	"default": EFFECTS.FLOWER,
	"crackle": EFFECTS.CRACKLE,
	"brocade": EFFECTS.BROCADE,
	"palm": EFFECTS.PALM
}

@export var ing_name: String
@export var ing_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var ing_sprite: CompressedTexture2D
@export var star_sprite: Texture2D = load("uid://ubw2obtraius")
@export var effect: EFFECTS = EFFECTS.FLOWER
@export var is_whistle: bool = false
@export var is_dud: bool = false

## Converts an EFFECTS enum value to its canonical string key.
static func translate(eff: EFFECTS) -> String:
	# Find the key string in our map where the value matches 'eff'
	var keys = KEY_MAP.keys()
	for k in keys:
		if KEY_MAP[k] == eff:
			return k
			
	push_warning("Invalid effect enum value: " + str(eff))
	return "unknown"

## Converts a canonical string key to its corresponding EFFECTS enum value.
static func key_to_effect(key: String) -> EFFECTS:
	# Use .get() to return the enum, or default to FLOWER if not found
	if not KEY_MAP.has(key):
		push_warning("Unrecognized effect key: " + key + ". Defaulting to FLOWER.")
	return KEY_MAP.get(key, EFFECTS.FLOWER)
 