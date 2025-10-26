extends Node3D
# ATTENTION la position de ce noeud bouge pas, c'est que le Skeleton3D qui bouge

@onready var physical_bone_head: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Head"
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var physical_bone_arm_l_end: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone arm_L_004"
@onready var physical_bone_arm_r_end: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone arm_R_004"
@onready var look_at_modifier_3d: LookAtModifier3D = $Armature/Skeleton3D/LookAtModifier3D


@export var playerToFollow : Player
@export var followForceHead := 400.0
@export var followForceArm := 80.0
@export var searchingPath : SplineCircuit
@export var loopTime := 50.0 # En secondes
@export var findDistance := 10.0
@export var multForceRushingPlayer := 5.0

var pathProgress := 0.0
var pathLength : float
var searchMode := true # Doit seulement être changé avec "_change_mode()"
var searchingCurve : Curve3D

func _ready() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
	look_at_modifier_3d.target_node = playerToFollow.get_path()
	searchingCurve = searchingPath.get_curve()
	pathLength = searchingCurve.get_baked_length()
	
func _physics_process(delta: float) -> void:
	
	var head_distance := (playerToFollow.global_position - physical_bone_head.global_position).length()
	change_search_mode(should_search(head_distance))
	var goal_pos := get_goal_pos(delta)
		
	var force_vec_head := (goal_pos - physical_bone_head.global_position).normalized()*followForceHead
	var force_arm_left := (goal_pos - physical_bone_arm_l_end.global_position).normalized()*followForceArm
	var force_arm_rigt := (goal_pos - physical_bone_arm_r_end.global_position).normalized()*followForceArm
	
	var multForce = 1.0 if searchMode else multForceRushingPlayer
	
	physical_bone_head.apply_central_impulse(force_vec_head * multForce * delta)
	physical_bone_arm_l_end.apply_central_impulse(force_arm_left * multForce * delta)
	physical_bone_arm_r_end.apply_central_impulse(force_arm_rigt * multForce * delta)
	
func get_goal_pos(delta: float) -> Vector3:
	if searchMode:
		pathProgress += delta/loopTime
		pathProgress = fmod(pathProgress, 1.0)
		return searchingPath.to_global(searchingCurve.sample_baked(pathProgress*pathLength))
		
	return playerToFollow.global_position

# Quand la créature se remet à chercher elle doit retourner vers
# le point du searchingPath le plus proche d'elle
func change_search_mode(search: bool):
	if search == searchMode: return
	if search:
		var create_local_pos = searchingPath.to_local(global_position)
		pathProgress = searchingCurve.get_closest_offset(create_local_pos)
		searchMode = true
	else:
		searchMode = false
	

func should_search(head_distance) -> bool:
	return head_distance > findDistance || playerToFollow.object_view
	
