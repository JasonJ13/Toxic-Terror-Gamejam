extends Control


var full_text : String
var act_line : String
var n_line : int = 0
var n_letter : int  = 0
var nmb_line_tot : int
var nmb_letter_tot : int

@onready var label : Label = $Label
@onready var timer : Timer = $Label/Timer

func _ready() -> void:
	var file = FileAccess.open("res://scenes/test_Jason/dialogue.txt",FileAccess.READ)
	full_text = file.get_as_text()
	file.close()
	nmb_line_tot = full_text.get_slice_count("]") + 1
	get_next_line()
	


func get_next_line()  -> void :
	
	act_line = full_text.get_slice("]",n_line)
	n_line += 1
	n_letter = 0
	nmb_letter_tot = act_line.length()
	timer.start()
	


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept") && n_line<nmb_line_tot :
		if n_letter == nmb_letter_tot : 
			get_next_line()
			n_line += 1
		else : 
			n_letter = nmb_letter_tot
			timer.stop()
			label.text = act_line
		

func next_letter() -> void:
	if n_letter < nmb_letter_tot : 
		n_letter += 1
		label.text = act_line.left(n_letter)
