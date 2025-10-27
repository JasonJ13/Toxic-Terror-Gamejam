extends Node3D

@onready var twoD : Control = $"2D"
@onready var sunset : Control = $"2D/Sunset"
@onready var menu : Control = $"2D/Menu"

var case_preload : Resource = preload("res://scenes/test_Jason/gestionCase.tscn")
var case : Control

var scene3DRessoure : Resource = preload("res://scenes/final_game/main.tscn")

var in_game : bool = false
var chap : int = 1

@onready var fade_in_black : AnimationPlayer= $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func start_3D() -> void :
	case.queue_free()
	
	if chap == 1 :
		add_child(scene3DRessoure.instantiate())


func end_anim(anim_name: StringName) -> void:
	
	if anim_name == "fade_in_black" :
		sunset.hide()
		menu.hide()
		start_diag()


func start_diag() -> void :
	case = case_preload.instantiate()
			
	twoD.add_child(case)
			
	case.connect('end_chap',Callable(self,'start_3D'))
	case.define_order(chap)
	case.next_case()
			
	fade_in_black.play("appeared")


func started_game_2D() -> void:
	menu.menu_working = false
	fade_in_black.play("fade_in_black")
