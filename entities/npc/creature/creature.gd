extends Node3D

@onready var physical_bone_head: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Head"
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var physical_bone_arm_l_end: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone arm_L_004"
@onready var physical_bone_arm_r_end: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone arm_R_004"
@onready var look_at_modifier_3d: LookAtModifier3D = $Armature/Skeleton3D/LookAtModifier3D



@export var toFollow : Node3D
@export var followForceHead := 8.0
@export var followForceArm := 1.0

func _ready() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
	look_at_modifier_3d.target_node = toFollow.get_path()
	
func _physics_process(delta: float) -> void:
	var force_vec_head = (toFollow.global_position - physical_bone_head.global_position)*followForceHead
	var force_arm_left = (toFollow.global_position - physical_bone_arm_l_end.global_position)*followForceArm
	var force_arm_rigt = (toFollow.global_position - physical_bone_arm_r_end.global_position)*followForceArm
	
	physical_bone_head.apply_central_impulse(force_vec_head * delta)
	physical_bone_arm_l_end.apply_central_impulse(force_arm_left * delta)
	physical_bone_arm_r_end.apply_central_impulse(force_arm_rigt * delta)
	
	
	
	
	
	
