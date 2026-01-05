extends Area2D

@export var part_texture : CompressedTexture2D
@export var ingredient : IngredientResource = IngredientResource.new()

var mouse_active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = part_texture
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(part_texture.get_image())

	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, part_texture.get_size()), 3)
	for poly in polys:
		var collision_polygon: CollisionPolygon2D = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		self.add_child(collision_polygon)


func _mouse_enter() -> void:
	mouse_active = true


func _mouse_exit() -> void:
	mouse_active = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_active:
			EventBus.request_ingredient.emit(self)
			print(ingredient.ing_name, " has effect ", ingredient.effect)
