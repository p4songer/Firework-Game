class_name CustomerDetail extends Control

## Displays the full notepad detail for a single NPC_Resource.
## Shows the NPC's name, active request, all auto-generated reviews,
## and allows the player to append new freeform notes.

@onready var name_label: Label = $ScrollContainer/Vbox/NameBox/Vbox/NameLabel
@onready var request_label: RichTextLabel = $ScrollContainer/Vbox/NameBox/Vbox/RequestLabel
@onready var review_box: VBoxContainer = $ScrollContainer/Vbox/ReviewBox
@onready var note_box: VBoxContainer = $ScrollContainer/Vbox/NoteBox
@onready var note_input: TextEdit = $ScrollContainer/Vbox/NoteBox/NoteInput
@onready var save_button: Button = $ScrollContainer/Vbox/SaveButton
@onready var close_button: Button = $ScrollContainer/Vbox/CloseButton
@onready var give_button: Button = $ScrollContainer/Vbox/GiveBox/Give
@onready var give_menu: MenuButton = $ScrollContainer/Vbox/GiveBox/GiveMenu

var _current_npc: NPC_Resource
var _popup : PopupMenu

func _ready() -> void:
	save_button.pressed.connect(_on_save_pressed)
	close_button.pressed.connect(_on_close_pressed)
	give_button.pressed.connect(_on_give_pressed)
	EventBus.notebook_updated.connect(_on_notebook_updated)
	visible = false

	_popup = give_menu.get_popup()
	_popup.id_pressed.connect(_on_give_menu_item_pressed)


## Loads an NPC_Resource into the detail view and refreshes all displayed content.
## npc: The NPC_Resource to display.
func load_npc(npc: NPC_Resource) -> void:
	print("loaded")
	_current_npc = npc
	_refresh()


## Refreshes all displayed content from the current NPC resource.
func _refresh() -> void:
	if _current_npc == null:
		return
	name_label.text = _current_npc.npc_name
	request_label.text = _current_npc.npc_request
	_populate_entries()


## Clears and repopulates the reviews and notes containers from notepad_entries.
func _populate_entries() -> void:
	for child: Node in review_box.get_children():
		child.queue_free()
	for child: Node in note_box.get_children():
		child.queue_free()

	for entry: Dictionary in _current_npc.notepad_entries:
		var label: RichTextLabel = RichTextLabel.new()
		label.fit_content = true
		label.bbcode_enabled = false
		if entry["type"] == "auto_review":
			label.text = entry["content"]
			review_box.add_child(label)
		elif entry["type"] == "player_note":
			label.text = "[%s]: %s" % [entry["author"], entry["content"]]
			note_box.add_child(label)


## Saves the current TextEdit content as a player note on the active NPC.
## Does nothing if the input is empty or no NPC is loaded.
func _on_save_pressed() -> void:
	if _current_npc == null:
		return
	var text: String = note_input.text.strip_edges()
	if text.is_empty():
		return
	_current_npc.add_player_note(text)
	note_input.text = ""


## Hides the detail panel and clears the current NPC reference.
func _on_close_pressed() -> void:
	visible = false
	_current_npc = null


## Refreshes displayed content when the notebook is updated for the currently displayed NPC.
## npc: The NPC_Resource that was updated.
func _on_notebook_updated(npc: NPC_Resource) -> void:
	if _current_npc == null or npc != _current_npc:
		return
	_populate_entries()


func _on_give_pressed() -> void:
	if _current_npc == null: return

	for item in Economy.get_all_fireworks().keys():
		give_menu.get_popup().add_item(item)
	give_menu.show_popup()


func _on_give_menu_item_pressed(id: int) -> void:
	var item = _popup.get_item_text(id)
	var firework = Economy.get_all_fireworks()[item]
	_current_npc.give_firework(firework["firework"])
 