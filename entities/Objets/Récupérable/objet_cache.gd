class_name Objet_cache extends  Recuperable
	
func _ready() -> void:
	outline_color=Color.CRIMSON
	outline_thickness=1.01

func take():
	print("objet")
	Globals.take_object()
	queue_free()
