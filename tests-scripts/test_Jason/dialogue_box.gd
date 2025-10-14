extends Control


var full_text : String
var act_line : String

var n_line : int = 0
var nmb_line_tot : int

var n_letter : int  = 0
var nmb_letter_tot : int

var carriage_return = 0

var n_jour : int = 0
var lst_obj : int = 0

@onready var scroll : ScrollContainer = $ScrollContainer
@onready var label : Label = $ScrollContainer/Label
@onready var timerLetter : Timer = $ScrollContainer/Label/TimerLetter
@onready var animationScroll : AnimationPlayer = $ScrollAnimation
@onready var timerScroll : Timer = $ScrollContainer/Label/TimerScroll

func _ready() -> void:
	var file = FileAccess.open("res://scenes/test_Jason/jour0/dialogue0.txt",FileAccess.READ)
	
	full_text = file.get_as_text()
	
	
	
	nmb_line_tot = full_text.get_slice_count("]") + 1
	get_next_line()
	
	file.close()
	


func get_next_line()  -> bool :
	
	if n_line < nmb_line_tot :
		act_line = full_text.get_slice("]",n_line)
		if n_line != 0 :
			act_line = act_line.right(-1)
		n_line += 1
		n_letter = 0
		carriage_return = 0
		nmb_letter_tot = act_line.length()
		timerLetter.start()
		return true
	else :
		return false


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept") && n_line<nmb_line_tot :
		if n_letter == nmb_letter_tot : 
			
			if not(get_next_line()) :
				pass
				# Changement de jour/ passage à la nuit
			
		else : 
			if carriage_return == 3 :
				animationScroll.play("scroll")
				timerScroll.start()
			
			else :
				n_letter = nmb_letter_tot
				timerLetter.stop()
				label.text = act_line
		

func next_letter() -> void:
	if n_letter < nmb_letter_tot && carriage_return < 3: 
		if act_line[n_letter] == '\n' :
			carriage_return += 1
		n_letter += 1
		label.text = act_line.left(n_letter)
		
		
func endScroll() -> void:
	var lost_ind : int = act_line.find("\n")
	var lost_line : int = act_line.left(lost_ind).length()
	
	act_line = act_line.right(-lost_ind)
	n_letter = n_letter - lost_line
	nmb_letter_tot = nmb_letter_tot - lost_line
	
	carriage_return = 2
	timerLetter.start()
