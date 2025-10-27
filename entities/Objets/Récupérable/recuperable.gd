@abstract class_name Recuperable extends Objet

@export var rotation_speed : float = 1.5

func take():
	assert(false,"fonction non implémenté")

func _process(delta: float) -> void:
	rotate_y(delta * rotation_speed)
