extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var head: Node3D = $Head
@onready var shapecast: ShapeCast3D = $Head/ShapeCast3D
@onready var reticle: ColorRect = $UI/Reticle

@export_range(0.0001, 0.01, 0.001) var sensitivity : float = 0.005

var shape_col : bool = false
var last_col : bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:
	# Update Reticle color when colliding.
	if shapecast.is_colliding():
		if shapecast.get_collider(0) is Target: shape_col = true
	else: shape_col = false
	update_ret()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(-event.relative.x * sensitivity)

		# Vertical look (up/down)
		head.rotate_x(-event.relative.y * sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if shapecast.is_colliding():
			var col = shapecast.get_collider(0)
			if col is Target:
				EventBus.target_clicked.emit(1)
				col.queue_free()


func update_ret() -> void:
	if shape_col != last_col:
		reticle.color = Color(0.0, 0.0, 0.0, 1.0) if shape_col else Color(1.0, 1.0, 1.0, 1.0)
		reticle.scale = Vector2(1.1, 1.1) if shape_col else Vector2.ONE
	last_col = shape_col


func _on_pause_menu_changed() -> void:
	reticle.visible = not reticle.visible
