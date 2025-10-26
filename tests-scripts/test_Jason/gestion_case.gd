extends Control

var order : String
var tot_case : int
var n_case : int = 0
var chap : int = 0

@onready var case : Control = $Case
var caseScene : Case


@onready var dialogueWOC : Control = $DialogueWOC

@onready var animation : AnimationPlayer = $TextAnimation

signal end_chap

func define_order(num_chap : int) -> void :
	chap = num_chap
	n_case = 0
	
	var file = FileAccess.open("res://assets/dialogue/order"+str(chap)+".txt",FileAccess.READ)
	order = file.get_as_text()
	file.close()
	
	tot_case = int(order.get_slice('/',0))


func next_case() -> void :
	
	
	if n_case != 0 :
		caseScene.queue_free()
	
	if n_case<tot_case :
		n_case += 1
		var strScene = order.get_slice('/',n_case)
		var caseressource : Resource = load("res://scenes/test_Jason/Case"+str(chap)+"/"+strScene+".tscn")
		print("res://scenes/test_Jason/Case"+str(chap)+"/"+strScene+".tscn")
		caseScene = caseressource.instantiate()
		
		case.add_child(caseScene)
		dialogueWOC.new_text(strScene,chap)
		animation.play("fondu_In")
	
	else :
		print("emit")
		end_chap.emit()


func end_dialogue() -> void:
	if $TextAnimation/Duration.is_stopped() :
		animation.play("fondu_Out")
		$TextAnimation/Duration.start()

func animation_ended() -> void:
	next_case()


func appeared_case() -> void:
	caseScene.appeared()


func new_line(n_line : int) -> void:
	caseScene.new_case(n_line)
