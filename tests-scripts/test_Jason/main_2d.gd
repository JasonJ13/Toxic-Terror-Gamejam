extends Control


var pre_scene : Resource = preload("res://scenes/test_Jason/gestionCase.tscn")

var in_game : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
	if Input.is_action_just_pressed("ui_accept") && !in_game:
		add_child(pre_scene.instantiate())
		in_game = true


func Start() -> void:
	pass # Replace with function body.
