extends Node2D

# ORDER #
"""
Make stars -> sequence -> package -> take bids -> <-
"""
var final_color : Color
var final_effect : int
var total_weight : float = 0.0:
	set(new):
		total_weight = new
		$Weight.text = "TOTAL WEIGHT: " + str(total_weight)

#var effects: Dictionary ={
	#"Brocade": {"active": false, "weight": 0.25},
	#"Crackle": {"active": false, "weight": 0.15},
	#"Palm": {"active": false, "weight": 0.05}
#}

func _ready() -> void:
	_update_labels()
	for b in $Vbox.get_children():
		if b is not Button: continue
		b.pressed.connect(_effect_button_pressed.bind(b.name))
		b.text = b.name


func _on_color_picker_color_changed(color: Color) -> void:
	$Chem.modulate = color
	_update_labels()


func _update_labels():
	for i in $Labels.get_child_count():
		var num = get_color(i)
		$Labels.get_child(i).text = $Labels.get_child(i).name + " (g): " + str(num * 0.001)
	total_weight = calculate_weight()


func get_color(num) -> int:
	match num:
		0:
			return $ColorPicker.color.r8
		1:
			return $ColorPicker.color.g8
		2:
			return $ColorPicker.color.b8
	return 0
"""
Max lift: 20g Max Break: 25% total weight
google example : 15g lift, 45g between break and stars. 15g break, 30g stars. Good dist. if stars are 1/4 g.
Fuses cost: Green(slow): $1.75 Pink(medium): $2 White(instant): $2.5
Cardboard tubes cost $0.5, cannot be used for SS or Mortar Sets.
Fiberglass tubes cost $6 for 1.75
Mortar sets must come with 1 tube per 6 shots.
"""
# TODO Make it so we can check this value to determine if the customer likes it. EG they like blue
# TODO Make little drop animation for updating colors.
# TODO Make tabs for order of creation. 
# TODO Make delivery system. Cake, Tube, Cardboard, Fiberglass
# TODO Make variable lift size, Shell size, Ounces etc. 60 Gram legal limit 1-2" ball, 1-4" canister

func _effect_button_pressed(button: String) -> void:
	match button:
		"Select":
			print("You can make up to %s stars." % str(30 / total_weight))
			final_color = $ColorPicker.color
			
			EventBus.room_completed.emit()
		"Brocade":
			final_effect = 2
			for b in $Vbox.get_children():
				if b.name == "Brocade" or b is Label: continue
				b.button_pressed = false
			print("press with charcoal to add a slow-burning effect")
		"Crackle":
			final_effect = 1
			for b in $Vbox.get_children():
				if b.name == "Crackle" or b is Label: continue
				b.button_pressed = false
			print("a mixture of different metals that burn at different speeds, creating the sparatic effect.")
		"Palm":
			final_effect = 3
			for b in $Vbox.get_children():
				if b.name == "Palm" or b is Label: continue
				b.button_pressed = false
			print("wrap with paper that will fall more slowly")
		_:
			print("Button not assigned.")
	
	total_weight = calculate_weight()


func calculate_weight() -> float:
	var num = 0.0
	#for k in effects.keys():
		#if effects[k].active:
			#num += effects[k].weight
	num += ($ColorPicker.color.r8 + $ColorPicker.color.g8 + $ColorPicker.color.b8) * 0.001
	return num
