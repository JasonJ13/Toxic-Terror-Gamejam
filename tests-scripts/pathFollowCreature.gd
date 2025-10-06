extends PathFollow3D

@export var speed_fact := 0.01

func _physics_process(delta: float) -> void:
	progress_ratio += speed_fact * delta
	
