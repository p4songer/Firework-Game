extends TextureProgressBar

@export var time: float 
@export var npc_data : NPC_Resource
var text_display : float

var display_info : bool = false
@onready var display: Label = $TimeDisplay
@onready var timer: Timer = $Timer
@onready var info: RichTextLabel = $Vbox/InfoBlock

var complete : bool = false
signal hovered
signal unhovered

func _ready() -> void:
	if time:
		timer.wait_time = time
		timer.start()
	else:
		push_error("No time set for %s. Make sure this is an NPC." % self.name)
	if not npc_data:
		push_error("NPC data is empty.")
	else:
		display.text = npc_data.npc_name
		info.text = npc_data.npc_statement


func _on_timer_timeout() -> void:
	if complete: 
		self.queue_free()
		return
	
	self.value = max(0, self.value - 1)
	if self.value == 0:
		complete = true


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.self_modulate = Color(0.0, 0.5, 0.192, 1.0)
		timer.stop()
		
		EventBus.qte_clicked.emit(npc_data)


func _on_mouse_entered() -> void:
	if display_info : 
		info.show()
		hovered.emit()


func _on_mouse_exited() -> void:
	if display_info : 
		info.hide()
		unhovered.emit()
