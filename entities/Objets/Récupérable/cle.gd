class_name Cle extends Recuperable
@onready var collect_sound: AudioStreamPlayer3D = $CollectSound

var taken := false

func _ready() -> void:
	outline_color = Color.GOLD
	outline_thickness = 1.015

func take():
	if taken: return
	print("cle")
	collect_sound.play()
	Globals.take_key()
	taken = true

func _physics_process(delta: float) -> void:
	rotate_y(delta * rotation_speed)


func _on_collect_sound_finished() -> void:
	queue_free()
