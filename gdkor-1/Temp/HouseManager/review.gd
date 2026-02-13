class_name Review extends HBoxContainer

@export var text_data : String
@export var sprite : CompressedTexture2D

@onready var rtl: RichTextLabel = $PanelContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rtl.text = text_data
	self.custom_minimum_size = $TextureRect.size + $PanelContainer.size
