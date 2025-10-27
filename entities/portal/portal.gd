class_name Portal
extends StaticBody3D

@export var close_color : Color
@export var open_color : Color

@onready var enter_zone: Area3D = $EnterZone
@onready var shader_mat: ShaderMaterial = $EnterZone/MeshInstance3D.get_active_material(0)
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

var portal_open := false

func _ready() -> void:
	shader_mat.set_shader_parameter("portal_tint", close_color)
	omni_light_3d.light_color = close_color
	Globals.open_portal_signal.connect(open_portal)
	
func open_portal() -> void:
	shader_mat.set_shader_parameter("portal_tint", open_color)
	omni_light_3d.light_color = open_color
	portal_open = true


func _on_enter_zone_body_entered(body: Node3D) -> void:
	if body is not Player: return
	
	if portal_open:
		print("end game gg")
	else:
		print("recupère toutes les clés")
	
