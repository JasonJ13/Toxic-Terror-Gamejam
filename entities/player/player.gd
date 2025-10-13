extends CharacterBody3D

var speed := 2.0
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var object_view := false

@onready var pitch_pivot := $PitchPivot
@onready var camera :=$PitchPivot/Camera3D

var default_camera_transform : Transform3D
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_camera_transform = camera.transform
	
	
func _process(delta: float) -> void:
	# --- Déplacement ---
	var input_dir := Vector3.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_back")
	input_dir = input_dir.normalized()

	var direction = (basis * input_dir)
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Gravité
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	else:
		velocity.y = 0.0

	move_and_slide()

	# --- Rotation ---
	rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -1.2, 1.2)

	twist_input = 0.0
	pitch_input = 0.0

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("change_view"):
		object_view=!object_view
		if object_view:
			camera.position=$ObjectViewPoint.position
		else:
			camera.transform = default_camera_transform
		print(object_view)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity
