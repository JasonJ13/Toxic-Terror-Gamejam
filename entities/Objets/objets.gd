class_name Objet extends StaticBody3D

@export var meshInstance : MeshInstance3D

var outline_color:=Color.WHITE
var outline_thickness: float = 1.03 # échelle du contour

func outline():
	# Supprime un ancien contour s’il existe déjà
	for child in meshInstance.get_children():
		if child.name == "OutlineMesh":
			child.queue_free()

	# Crée un doublon pour le contour
	var outline = MeshInstance3D.new()
	outline.name = "OutlineMesh"
	outline.mesh = meshInstance.mesh
	outline.scale = meshInstance.scale * outline_thickness  # un peu plus grand
	outline.material_override = create_outline_material()
	outline.visible = true
	outline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Ajoute le contour comme enfant (affiché derrière)
	meshInstance.add_child(outline)
	outline.owner = meshInstance.get_tree().current_scene
	
func remove_outline():
	for child in meshInstance.get_children():
		if child.name == "OutlineMesh":
			child.queue_free()
	
func create_outline_material() -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = """
		shader_type spatial;
		render_mode unshaded, cull_front; // on inverse le cull pour voir l'envers

		uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
		void fragment() {
			ALBEDO = outline_color.rgb;
			ALPHA = 1.0;
		}
	"""
	var mat = ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("outline_color", outline_color)
	return mat
