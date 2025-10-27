extends ColorRect

class_name Case

@export var num_line_jump: Array[int] = []
@export var animation_tab: Array[AnimationPlayer]

var n_case : int = 0
var last_case : bool = false

func new_case(line : int) :
	
	if !num_line_jump.is_empty() && !last_case :
		if line == num_line_jump[n_case] :
			animation_tab[n_case].play("fade_in")
			n_case += 1
			
			if n_case == num_line_jump.size() :
				last_case = true
