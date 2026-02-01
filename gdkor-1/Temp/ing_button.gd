extends TextureButton

@export_multiline("Type Here") var ing_text : String
@export var ing_name : String
@export var sprite : CompressedTexture2D

var origin : Vector2

var clicked: bool = false
var click_offset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ing_name or not sprite or not ing_text:
		push_error("%s does not have correct exports. Check the code" % self.name)
		return
	self.texture_normal = sprite
	$Label.text = ing_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if clicked:
		self.global_position = get_global_mouse_position() - click_offset


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clicked = true
		click_offset = get_global_mouse_position() - self.global_position
		origin = self.global_position
	elif clicked and event is InputEventMouseButton and event.is_released():
		clicked = false
		detect_areas()
		self.global_position = origin


func detect_areas() -> void:
	if $Area2D.has_overlapping_areas():
		for a in $Area2D.get_overlapping_areas():
			if a.is_in_group("ing_area"):
				print("Added %s" % ing_name)
