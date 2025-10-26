extends Control

var n_letter : int = 0
@onready var label : Label = $Label

signal end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass




func next_letter() -> void:
		
		n_letter += 1
		#label.text = act_line.left(n_letter)
