extends Control

var order : String
var tot_case : int
var n_case : int = 0

@onready var case : Control = $Case
var caseScene : Control

@onready var dialogueWOC : Control = $DialogueWOC

@onready var animation : AnimationPlayer = $TextAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	define_order()
	next_case()


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func define_order() -> void :
	var file = FileAccess.open("res://assets/dialogue/order1.txt",FileAccess.READ)
	order = file.get_as_text()
	file.close()
	
	tot_case = int(order.get_slice('/',0))


func next_case() -> void :
	
	if n_case != 0 :
		caseScene.queue_free()
	
	if n_case<tot_case :
		n_case += 1
		var strScene = order.get_slice('/',n_case)
		var caseressource : Resource = load("res://scenes/test_Jason/Case/"+strScene+".tscn")
		print("res://scenes/test_Jason/Case/"+strScene+".tscn")
		caseScene = caseressource.instantiate()
		dialogueWOC.new_text(strScene)
		
		case.add_child(caseScene)
		animation.play("fondu_In")
	
	else :
		print("dialogue finit")


func end_dialogue() -> void:
	if $TextAnimation/Duration.is_stopped() :
		animation.play("fondu_Out")
		$TextAnimation/Duration.start()

func animation_ended() -> void:
	next_case()
