class_name FireworkResource extends Resource


#Smoke for daytime. Optional for now.
enum STYLE {BIG_CAKE, CAKE, CANDLE, NOAB, MORTAR, SINGLE_SHOT, ROCKET, SPARKLER, SMOKE_BOMB, SMOKE_TUBE, SMOKE_CAKE}
@export var firework_style: STYLE ## Select the style of firework.
@export var sequence : Array ## Needs to have at least 1 element to display.
@export var display_name : String
@export var display_sprite : String
