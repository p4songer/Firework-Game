extends Area2D

@export var part_texture : CompressedTexture2D

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
	print("mouse")


func _mouse_exit() -> void:
	print("mose gone")
