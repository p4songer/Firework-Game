extends Sprite2D

var active_area : Area2D
var popup : PopupMenu

@onready var menu: MenuButton = $MenuButton

func _ready() -> void:
	for area in self.get_children():
		if area is Area2D:
			area.mouse_entered.connect(_on_mouse_entered.bind(area))
			area.mouse_exited.connect(_on_mouse_exited.bind(area))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if not active_area: return
		
		menu.global_position = get_global_mouse_position()
		menu.show_popup()


func _on_mouse_entered(which: Area2D) -> void:
	active_area = which


func _on_mouse_exited(which: Area2D) -> void:
	if active_area == which:
		active_area = null


func _on_menu_button_about_to_popup() -> void:
	if not popup:
		popup = menu.get_popup()
		popup.index_pressed.connect(_pop_menu_selected)
		var popup_arr = Global.get_dict_array("text")
		for p in popup_arr:
			popup.add_item(p)


func _pop_menu_selected(index: int) -> void:
	Global.firework_index = index
	update_text()


func update_text() -> void:
	# TODO Make this a global issue, not a local issue
	menu.text = Global.get_dict_item("text")
	EventBus.color_changed.emit(Global.get_dict_item("color"))
