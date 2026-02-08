extends Node2D

@onready var grain_holder: Node2D = $GrainHolder
@onready var jar_area: Area2D = $Sprite2D/Area2D

var final_color : Color

func _ready() -> void:
	EventBus.new_grain.connect(_on_new_grain)


func _process(_delta: float) -> void:
	if grain_holder.get_child_count() > 765:
		grain_holder.get_child(0).queue_free()


func add_grain(new_grain) -> void:
	grain_holder.add_child(new_grain)


func toggle_camera(active : bool) -> void:
	$Camera2D.enabled = active


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("pitcher"):
		await get_tree().create_timer(0.1).timeout
		print("area ", jar_area.get_overlapping_bodies().size())
		
		var new_color : Color
		for g in jar_area.get_overlapping_bodies():
			@warning_ignore("narrowing_conversion")
			new_color.r8 += g.modulate.r
			@warning_ignore("narrowing_conversion")
			new_color.b8 += g.modulate.b
			@warning_ignore("narrowing_conversion")
			new_color.g8 += g.modulate.g
		$Chem.modulate = new_color


func _on_new_grain(grain) -> void:
	grain_holder.add_child(grain)


func _on_button_pressed() -> void:
	final_color = $Chem.modulate
