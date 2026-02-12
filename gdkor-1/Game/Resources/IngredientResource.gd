class_name IngredientResource extends Resource

enum EFFECTS {
	FLOWER, CRACKLE, BROCADE, PALM
}

@export var ing_name : String
@export var ing_color : Color = Color(1.0, 1.0, 1.0, 1.0)
@export var ing_sprite : CompressedTexture2D
@export var star_sprite : Texture2D = load("uid://ubw2obtraius") # Default star
@export var effect : int = 0 ## Should be an enum to indicate what effect is.
@export var is_whistle : bool = false
