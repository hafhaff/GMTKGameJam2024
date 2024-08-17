extends Node2D

class_name box
	
@export var itemNum = 10
@export var itemName : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body == $"../../Player":
		print("bruh")
		
	else: 
		pass # Replace with function body.
