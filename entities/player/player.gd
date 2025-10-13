extends CharacterBody3D

var speed := 2.0
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var object_view := false

@onready var pitch_pivot := $PitchPivot
@onready var camera :=$PitchPivot/Camera3D
@onready var raycast = $RayCast3D

var default_camera_transform : Transform3D
var default_shape: Shape3D
var default_mesh: Mesh
var collider_offset_y := 0.0
var default_collider_offset_y := 0.0
	
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
			if copy_mesh():
				camera.position=$ObjectViewPoint.position
			else:
				object_view!=object_view
		else:
			$CollisionShape3D.shape=default_shape
			$MeshInstance3D.mesh=default_mesh
			var old_center = collider_offset_y  # centre précédent
			var new_center = default_collider_offset_y
			# Ajuster la position verticale pour compenser
			position.y += (new_center - old_center)
			collider_offset_y = new_center  # mettre à jour l'offset
		
			
			camera.transform = default_camera_transform
			
			
		
		
func copy_mesh()->bool:
	raycast.global_transform.origin = camera.global_transform.origin
	raycast.global_transform.basis = camera.global_transform.basis

 
	raycast.force_raycast_update()  # s'assure que le raycast est à jour
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
			# Vérifier si l'objet a un MeshInstance
		var mesh_instance = find_mesh_instance(collider)
		if not mesh_instance.is_in_group("copiable"):
			print("Objet non copiable")
			return false
		if mesh_instance:
			# Copier le mesh
			var player_mesh = $MeshInstance3D  # ton mesh actuel du joueur
			player_mesh.mesh = mesh_instance.mesh
			print("Joueur transformé en l'objet touché !")

			# Si tu veux, tu peux aussi ajuster le collider du joueur
			var shape = mesh_instance.mesh.create_convex_shape()
			if shape:
				var collision_shape = $CollisionShape3D  # collider actuel du joueur
				var old_center = collider_offset_y  # centre précédent
				collision_shape.shape = shape
				var new_center = get_collider_center_y(shape,mesh_instance.mesh)

				# Ajuster la position verticale pour compenser
				position.y += (new_center - old_center)
				collider_offset_y = new_center  # mettre à jour l'offset
	
				print("Collider du joueur mis à jour !")
				return(true)
				
		else:
			print("Pas de MeshInstance trouvé sur cet objet.")
	return false


func find_mesh_instance_in_children(node: Node) -> MeshInstance3D:
	for child in node.get_children():
		var found = find_mesh_instance_in_children(child)
		if found:
			return found
	return null
	
func find_mesh_instance(collider: Node) -> MeshInstance3D:
	var node = collider
	while node:
		if node is MeshInstance3D:
			return node
		node = node.get_parent()
	return find_mesh_instance_in_children(collider)
	
	
func draw_ray(start_pos: Vector3, end_pos: Vector3, color: Color):
	var line = ImmediateMesh.new()
	line.surface_begin(Mesh.PRIMITIVE_LINES)
	line.surface_set_color(color)
	line.surface_add_vertex(start_pos)
	line.surface_add_vertex(end_pos)
	line.surface_end()

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = line
	add_child(mesh_instance)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity
