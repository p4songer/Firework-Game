extends TextureButton

@export var ing_name : String
@export var sprite : CompressedTexture2D

var clicked: bool = false
#drag stuff to stuff.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ing_name or not sprite:
		push_error("%s does not have correct exports. Check the code" % self.name)
		return
	self.texture_normal = sprite
	$Label.text = ing_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
