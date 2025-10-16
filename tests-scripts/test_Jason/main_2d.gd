extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func end_dialogue() -> void:
	print('switch')
	
	$DialogueWOC.queue_free()
	$Control/ParentScene.queue_free()
	
	$Control/BullyScene.show()
