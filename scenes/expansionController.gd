extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


signal update (bool)

func _on_right_expand_input_event(viewport, event, shape_idx):
	update.emit(true)
	pass # Replace with function body.


func _on_left_expand_input_event(viewport, event, shape_idx):
	update.emit(true)
	pass # Replace with function body.


func _on_down_expand_input_event(viewport, event, shape_idx):
	update.emit(true)
	pass # Replace with function body.
