extends Node2D

@export var time: float 
@export var npc_data : NPC_Resource
var text_display : float

@onready var progress: TextureProgressBar = $TextureProgressBar
@onready var display: Label = $TextureProgressBar/TimeDisplay
@onready var timer: Timer = $Timer

var complete : bool = false

func _ready() -> void:
	if not time:
		push_error("No time set for %s. Double check this code." % self.name)
	if not npc_data:
		push_error("NPC data is empty.")
	display.text = npc_data.npc_name
	timer.wait_time = time
	timer.start()


func _on_timer_timeout() -> void:
	if complete: 
		self.queue_free()
		return
	
	progress.value = max(0, progress.value - 1)
	if progress.value == 0:
		complete = true


func _on_texture_progress_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		progress.self_modulate = Color(0.0, 0.5, 0.192, 1.0)
		timer.stop()
		
		EventBus.qte_clicked.emit(npc_data)
