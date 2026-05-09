class_name IngredientResource extends Resource

enum EFFECTS {
	FLOWER, CRACKLE, BROCADE, PALM
}

@export var ing_name: String
@export var ing_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var ing_sprite: CompressedTexture2D
@export var star_sprite: Texture2D = load("uid://ubw2obtraius")
@export var effect: EFFECTS = EFFECTS.FLOWER
@export var is_whistle: bool = false
@export var is_dud: bool = false

## Converts an EFFECTS enum value to its canonical string key.
## Used for storage, serialization, and display translation.
## eff: The EFFECTS enum value to translate.
static func translate(eff: EFFECTS) -> String:
	match eff:
		EFFECTS.FLOWER:
			return "default"
		EFFECTS.CRACKLE:
			return "crackle"
		EFFECTS.BROCADE:
			return "brocade"
		EFFECTS.PALM:
			return "palm"
		_:
			push_warning("Invalid effect enum value: " + str(eff))
			return "unknown"

## Converts a canonical string key to its corresponding EFFECTS enum value.
## Returns EFFECTS.FLOWER as a safe default if the key is not recognized.
## key: The string key to look up.
static func key_to_effect(key: String) -> EFFECTS:
	match key:
		"default":
			return EFFECTS.FLOWER
		"crackle":
			return EFFECTS.CRACKLE
		"brocade":
			return EFFECTS.BROCADE
		"palm":
			return EFFECTS.PALM
		_:
			push_warning("Unrecognized effect key: " + key + ". Defaulting to FLOWER.")
			return EFFECTS.FLOWER
