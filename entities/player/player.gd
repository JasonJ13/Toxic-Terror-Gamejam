extends CharacterBody3D

var speed := 2.0
var default_speed:=2.0
var object_speed:=0.2
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var object_view := false
var jump_speed := 6.0

@onready var pitch_pivot := $PitchPivot
@onready var camera :=$PitchPivot/Camera3D
@onready var raycast = $RayCast3D

var default_camera_transform : Transform3D
var default_shape: Shape3D
var default_mesh: Mesh
var collider_offset_y := 0.0
var default_collider_offset_y := 0.0

@export var outline_material: Material
var highlighted_object: Copiable = null
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_camera_transform = camera.transform
	default_shape=$CollisionShape3D.shape
	default_mesh=$MeshInstance3D.mesh
	collider_offset_y = get_collider_center_y(default_shape,default_mesh)
	default_collider_offset_y = collider_offset_y
	
	
func get_collider_center_y(shape: Shape3D, mesh: Mesh) -> float:
	if shape is CapsuleShape3D:
		return shape.height / 2
	elif shape is ConvexPolygonShape3D:
		if mesh:
			return mesh.get_aabb().size.y / 2
	return 0.0

	
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
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
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
				object_view!=object_view
		else:
			$CollisionShape3D.shape=default_shape
			$MeshInstance3D.mesh=default_mesh
			$MeshInstance3D.scale = Vector3(0.4,1,0.4)
			var old_center = collider_offset_y  # centre précédent
			var new_center = default_collider_offset_y
			# Ajuster la position verticale pour compenser
			position.y += (new_center - old_center)
			collider_offset_y = new_center  # mettre à jour l'offset
			camera.transform = default_camera_transform
			
			speed=default_speed
			
			
		
func processRaycast():
	raycast.global_transform.origin = camera.global_transform.origin
	raycast.global_transform.basis = camera.global_transform.basis

 
	raycast.force_raycast_update()  # s'assure que le raycast est à jour
	if raycast.is_colliding():
		var collide = raycast.get_collider()
		if collide is Copiable:
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
	if highlighted_object:
		$MeshInstance3D.mesh  = highlighted_object.meshInstance.mesh
		$MeshInstance3D.scale = Vector3(1,1,1)
		var shape = $MeshInstance3D.mesh.create_convex_shape()
		$CollisionShape3D.shape=shape
		
		#Déplacer le center pour pas tomber à travers le sol
		var old_center = collider_offset_y  
		var new_center = get_collider_center_y(shape,highlighted_object.meshInstance.mesh)
		position.y += (new_center - old_center)
		collider_offset_y = new_center  
		
		#On désactive le surlignage quand on prend la forme de l'objet
		highlighted_object.remove_outline() 
		highlighted_object=null
		return(true)
	return false

	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity
	if event is InputEventMouseButton and event.pressed:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
