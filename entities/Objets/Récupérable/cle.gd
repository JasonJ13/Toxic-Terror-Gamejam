class_name Cle extends Recuperable

func _ready() -> void:
	outline_color = Color.GOLD
	outline_thickness = 1.015

func take():
	print("cle")
	Globals.take_key()
	queue_free()

func _physics_process(delta: float) -> void:
	rotate_y(delta * rotation_speed)
