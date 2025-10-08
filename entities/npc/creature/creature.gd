extends Node3D

@export var physical_bone_simulator_3d: PhysicalBoneSimulator3D 
@export var physical_bone_head: PhysicalBone3D 


@export var toFollow : Node3D
@export var followForce := 10.0

func _ready() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
	
func _physics_process(delta: float) -> void:
	var force_vec = (toFollow.global_position - physical_bone_head.global_position)*followForce
	physical_bone_head.apply_central_impulse(force_vec)
	
	
