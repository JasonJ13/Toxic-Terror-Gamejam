extends Control

var full_text : String
var act_line : String

var n_line : int = 0
var nmb_line_tot : int

var n_letter : int  = 0
var nmb_letter_tot : int

var carriage_return = 0

var scroll : ScrollContainer 
var label : Label
var timerLetter : Timer
var animationScroll : AnimationPlayer
var timerScroll : Timer

signal signal_line
signal end_dialogue

func _ready() -> void:
	scroll = $ScrollContainer
	label = $ScrollContainer/Label
	timerLetter = $ScrollContainer/Label/TimerLetter
	animationScroll = $ScrollAnimation
	timerScroll = $ScrollContainer/Label/TimerScroll
	

func new_text(file_name : String, chap : int) -> void:
	var file = FileAccess.open("res://assets/dialogue/order"+str(chap)+"/"+file_name+".txt",FileAccess.READ)
	print()
	full_text = file.get_as_text()
	
	nmb_line_tot = full_text.get_slice_count("]") - 1
	n_line = 0
	
	get_next_line()
	
	file.close()
	
	timerLetter.start()


func get_next_line()  -> bool :
	
	if n_line < nmb_line_tot :
		signal_line.emit(n_line)
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
		label.text = ""
		return false


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept") && timerScroll.is_stopped() :
		timerLetter.wait_time = 0.05
		if n_letter == nmb_letter_tot : 
			
			if not(get_next_line()) :	#Ce n'est pas qu'une condition, ça fait aussi des trucs
				end_dialogue.emit()
				# Changement de jour/ passage à la nuit
			
		else : 
			if carriage_return == 3 :
				label.text += '\n'
				animationScroll.play("scroll")
				timerScroll.start()
			
			else :
				timerLetter.wait_time = 0.001
		

func next_letter() -> void:
	if n_letter < nmb_letter_tot && carriage_return < 3 : 
		if act_line[n_letter] == '\n' :
			carriage_return += 1
			
		
			if carriage_return == 3 :
				n_letter += 1
				return 
		
		n_letter += 1
		label.text = act_line.left(n_letter)
		
		
func endScroll() -> void:
	var lost_ind : int = act_line.find("\n") +1
	var lost_line : int = act_line.left(lost_ind).length()
	
	act_line = act_line.right(-lost_ind)
	n_letter = n_letter - lost_line
	nmb_letter_tot = nmb_letter_tot - lost_line
	
	carriage_return = 2
	timerLetter.start()
