extends Sprite2D

@export var ingredient : IngredientResource = IngredientResource.new()

var is_onscreen : bool = false
var mouse_active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.part_finished.connect(_on_part_finished)
	EventBus.color_button_pressed.connect(_on_color_button_pressed)
	EventBus.effect_button_pressed.connect(_on_effect_button_pressed)
	#$Sprite2D.texture = part_texture
	#var bitmap = BitMap.new()
	#bitmap.create_from_image_alpha(part_texture.get_image())
#
	#var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, part_texture.get_size()), 3)
	#for poly in polys:
		#var collision_polygon: CollisionPolygon2D = CollisionPolygon2D.new()
		#collision_polygon.polygon = poly
		#self.add_child(collision_polygon)
		#collision_polygon.position = - $Sprite2D.get_rect().size / 2


func _mouse_enter() -> void:
	mouse_active = true


func _mouse_exit() -> void:
	mouse_active = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_active:
			print("clicked part")


func _on_part_finished() -> void:
	if is_onscreen:
		Global.active_fireworks.append(ingredient)
		ingredient = IngredientResource.new()


func _on_color_button_pressed() -> void:
	if is_onscreen:
		EventBus.request_ingredient.emit(self)
		print(self.name, " has color ", ingredient.ing_name, " has effect ", ingredient.effect)


func _on_effect_button_pressed() -> void:
	if is_onscreen:
		EventBus.request_ingredient.emit(self)
		print(self.name, " has color ", ingredient.ing_name, " has effect ", ingredient.effect)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_onscreen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_onscreen = false
