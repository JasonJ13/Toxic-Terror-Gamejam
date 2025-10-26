extends Case

@onready var animation2 : AnimationPlayer = $Case1/AnimationBus
@onready var animation3 : AnimationPlayer = $Case2/AnimationBus


func In2_finished(anim_name: StringName) -> void:
	
	if anim_name == 'fade_in' :
		animation2.play("busAnimation")


func In3_finished(anim_name: StringName) -> void:
		if anim_name == 'fade_in' :
			animation3.play("busAnimation")
