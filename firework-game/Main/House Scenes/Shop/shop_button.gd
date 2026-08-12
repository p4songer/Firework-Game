extends VBoxContainer

@export var item_name : String = "item"
@onready var selection: HBoxContainer = $Selection
@onready var label: Label = $Selection/Label

var value : int = 0

func _ready() -> void:
	for c in selection.get_children():
		if c is Button:
			c.pressed.connect(_on_button_pressed.bind(c.name))
	$Icon.pressed.connect(_on_purchase_pressed)


func _on_button_pressed(button_name: String) -> void:
	value = max(0, int(button_name) + value)
	label.text = str(value)


func _on_purchase_pressed() -> void:
	print_debug("Purchasing " + str(value) + " " + item_name)
