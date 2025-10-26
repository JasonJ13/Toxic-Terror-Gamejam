class_name Player
extends CharacterBody3D

@export var default_speed := 2.0
@export var object_speed:=0.2
@export var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var object_view := false
@export var jump_speed := 6.0

@export var option_menu: Control


@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot
@onready var camera: Camera3D = $TwistPivot/PitchPivot/Camera3D

@onready var raycast: RayCast3D = $TwistPivot/PitchPivot/RayCast3D

@onready var speed := default_speed

var default_camera_transform : Transform3D
var default_shape: Shape3D
var default_mesh: Mesh

var highlighted_object: Objet = null
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_camera_transform = camera.transform
	default_shape=$CollisionShape3D.shape
	default_mesh=$MeshInstance3D.mesh
	
func get_collider_center_y(shape: Shape3D, mesh: Mesh) -> float:
	if shape is CapsuleShape3D:
		return shape.height / 2
	elif shape is ConvexPolygonShape3D:
		if mesh:
			return mesh.get_aabb().size.y / 2
	return 0.0

func deplacement(delta):
	var input_dir := Vector3.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_back")
	input_dir = input_dir.normalized()
	var direction = (twist_pivot.global_basis * input_dir)
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Gravité
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
		else:
			velocity.y = 0.0
			
func rotation():
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -1.2, 1.2)

	twist_input = 0.0
	pitch_input = 0.0
	
func _process(delta: float) -> void:
	if !object_view:
		deplacement(delta)
		move_and_slide()

	rotation()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		option_menu.visible=true
		
	#Si le joueur n'est pas pas un objet on surligne les objet dont il peut prendre la forme
	if !object_view:
		processRaycast()
		
	if Input.is_action_just_pressed("change_view"):
		object_view=!object_view
		if object_view:
			if change_to_object():
				camera.position=$ObjectViewPoint.position
				speed=object_speed
			else:
				object_view = false
		else:
			$CollisionShape3D.shape=default_shape
			$MeshInstance3D.mesh=default_mesh
			$MeshInstance3D.scale = Vector3(0.4,1,0.4)
			camera.transform = default_camera_transform
			speed = default_speed
		
func processRaycast():
	raycast.force_raycast_update()  # s'assure que le raycast est à jour
	if raycast.is_colliding():
		var collide = raycast.get_collider()
		if collide is Objet:
			# Applique le contour si c’est un nouvel objet
			if highlighted_object != collide:
				if highlighted_object:
					highlighted_object.remove_outline()
				collide.outline()
				highlighted_object = collide
		else:
			# Si ce n’est pas un objet copiable
			if highlighted_object:
				highlighted_object.remove_outline()
				highlighted_object = null
	else:
		# Si le raycast ne touche rien
		if highlighted_object:
			highlighted_object.remove_outline()
			highlighted_object = null
		
func change_to_object()->bool:
	if highlighted_object is Copiable:
		$MeshInstance3D.mesh  = highlighted_object.meshInstance.mesh
		$MeshInstance3D.material_override = highlighted_object.meshInstance.get_active_material(0)
		$MeshInstance3D.scale = Vector3(1,1,1)
		
		#On désactive le surlignage quand on prend la forme de l'objet
		highlighted_object.remove_outline() 
		highlighted_object=null
		return true
	return false

	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity
	if event is InputEventMouseButton and event.pressed:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			if !option_menu.visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			if highlighted_object is Recuperable:
				highlighted_object.take()
				highlighted_object=null
