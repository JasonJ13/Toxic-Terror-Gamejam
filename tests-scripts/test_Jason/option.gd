extends Control

@export var audio_bus_name : String

var audio_bus_id
func _ready() -> void:
	visible=false
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)

func _on_reprendre_pressed() -> void:
	visible=false

func _on_audio_value_changed(value: float) -> void:
	var db=linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id,db)


func _on_full_screen_control_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$Panel/FullScreenControl/On.show()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$Panel/FullScreenControl/On.hide()


func _on_quitter_pressed() -> void:
	pass # Replace with function body.
