extends ColorRect

@onready var animation2 : AnimationPlayer = $Bus2/AnimationBus
@onready var animation3 : AnimationPlayer = $Bus3/AnimationBus
@onready var timerstart : Timer = $Timer

var n_case = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && n_case == 2 :
		animation3.play("case_in")
		n_case = 3

	if Input.is_action_just_pressed("ui_accept") && n_case == 1 && timerstart.is_stopped():
		animation2.play("case_in")
		n_case = 2


func In2_finished(anim_name: StringName) -> void:
	
	if anim_name == 'case_in' :
		animation2.play("busAnimation")


func In3_finished(anim_name: StringName) -> void:
		if anim_name == 'case_in' :
			animation3.play("busAnimation")
