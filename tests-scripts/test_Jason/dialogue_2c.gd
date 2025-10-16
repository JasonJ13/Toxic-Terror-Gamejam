extends Control


@onready var arrow : TextureRect = $Arrow
var position_is : bool = true # true = gauche, false = right

signal end_dialogue(choice)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("move_right") && position_is :
		arrow.position.x = 487
		position_is = false
	
	if Input.is_action_just_pressed("move_left") && not(position_is) :
		arrow.position.x = 159
		position_is = true
	
	if Input.is_action_just_pressed("ui_accept") : 
		end_dialogue.emit(position_is)
