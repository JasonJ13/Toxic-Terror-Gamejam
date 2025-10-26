extends Node

var objets_a_recuperer=1
var objets_recuperes := 0

func add_object():
	objets_recuperes+=1
	
func get_atteint():
	if objets_recuperes==objets_a_recuperer:
		return (true)
	else:
		return(false)
