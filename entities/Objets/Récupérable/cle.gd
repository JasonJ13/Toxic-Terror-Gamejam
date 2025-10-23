class_name Cle extends  Recuperable
	
func _ready() -> void:
	outline_color=Color.GOLD
	outline_thickness=1.015

func take():
	print("clé récupre")
	queue_free()
