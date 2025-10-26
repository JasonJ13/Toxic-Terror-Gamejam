extends Control


var case_preload : Resource = preload("res://scenes/test_Jason/gestionCase.tscn")
var case : Control

var in_game : bool = false

@onready var fade_in_black : AnimationPlayer= $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
	if Input.is_action_just_pressed("ui_accept") && !in_game:
		fade_in_black.play("fade_in_black")
		in_game = true



func start_3D() -> void :
	case.queue_free()
	print("start game")


func end_anim(anim_name: StringName) -> void:
	
	if anim_name == "fade_in_black" :
		start_diag(1)


func start_diag(chap : int) -> void :
	case = case_preload.instantiate()
			
	add_child(case)
			
	case.connect('end_chap',Callable(self,'start_3D'))
	case.define_order(chap)
	case.next_case()
			
	fade_in_black.play("appeared")
