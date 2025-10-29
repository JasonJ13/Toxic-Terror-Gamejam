extends Control

var n_position : int = 0
var tab_position : Array[Vector2i] = [Vector2(300,183),Vector2(264,273),Vector2(316,361),Vector2(228,449)]
var menu_working = true

@onready var arrow : Sprite2D = $Arrow

signal Game_started
signal Option

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow.position = tab_position[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("move_back") && n_position <3 :
		n_position += 1
		arrow.position = tab_position[n_position]
	
	if Input.is_action_just_pressed("move_forward") && n_position >0 :
		n_position -= 1
		arrow.position = tab_position[n_position]

	if Input.is_action_just_pressed("ui_accept") :
		
		if menu_working :
			match n_position :
				0 :
					option1()
					
				1 :
					option2()
					#Ajout d'une scène pour les menues
					
				2 :
					option3()
					#Ajout d'une scène pour les crédits
					
				3 :
					option4()


func option1() -> void :
	Game_started.emit()


func option2() -> void :
	Option.emit()

func option3() -> void :
	pass

func option4() -> void :
	get_tree().quit()
