class_name IngredientResource extends Resource

enum EFFECTS {FLOWER, CRACKLE, BROCADE, PALM}

# A clean, centralized dictionary to map your custom string keys to the enum values
const KEY_MAP: Dictionary = {
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
	# Looks up the string key by finding the enum value in the dictionary keys
	var keys = KEY_MAP.keys()
	for key in keys:
		if KEY_MAP[key] == eff:
			return key
	
	push_warning("Invalid effect enum value: " + str(eff))
	return "unknown"

## Converts a canonical string key to its corresponding EFFECTS enum value.
static func key_to_effect(key: String) -> EFFECTS:
	# Using .get() ensures a safe fallback to EFFECTS.FLOWER if the key doesn't exist,
	# and we use "as EFFECTS" to satisfy GDScript's strict type checker.
	return KEY_MAP.get(key, EFFECTS.FLOWER) as EFFECTS
