class_name Review extends HBoxContainer

@export var data : NPC_Resource
@export var sprite : CompressedTexture2D

@onready var rtl: RichTextLabel = $PanelContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rtl.text = data.given_review
	$TextureRect.texture = data.npc_sprite
	self.custom_minimum_size = $TextureRect.size + $PanelContainer.size
