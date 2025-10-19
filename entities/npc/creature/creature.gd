extends Node3D

@onready var physical_bone_head: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Head"
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var physical_bone_arm_l_end: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone arm_L_004"
@onready var physical_bone_arm_r_end: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone arm_R_004"
@onready var look_at_modifier_3d: LookAtModifier3D = $Armature/Skeleton3D/LookAtModifier3D


@export var playerToFollow : Node3D
@export var searchingPath : Path3D
@export var followForceHead := 8.0
@export var followForceArm := 1.0
@export var upOffset := 5.0
@export var headDownDistance := 10.0




func _ready() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
	look_at_modifier_3d.target_node = playerToFollow.get_path()
	
func _physics_process(delta: float) -> void:
	
	var goal_pos := playerToFollow.global_position 
	var head_distance := (playerToFollow.global_position - physical_bone_head.global_position).length()
	if head_distance > 5.0:
		goal_pos += Vector3.UP * upOffset
	
	print(goal_pos)
	var force_vec_head := (goal_pos - physical_bone_head.global_position)*followForceHead
	var force_arm_left := (goal_pos - physical_bone_arm_l_end.global_position)*followForceArm
	var force_arm_rigt := (goal_pos - physical_bone_arm_r_end.global_position)*followForceArm
	
	physical_bone_head.apply_central_impulse(force_vec_head * delta)
	physical_bone_arm_l_end.apply_central_impulse(force_arm_left * delta)
	physical_bone_arm_r_end.apply_central_impulse(force_arm_rigt * delta)
	
	

	
	
	
