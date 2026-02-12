extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.custom_minimum_size = $TextureRect.size + $PanelContainer.size
