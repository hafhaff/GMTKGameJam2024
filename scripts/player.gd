extends CharacterBody2D

@export var speed: float = 100

var heldItem : Node
var heldItemNum

func _ready():
	position = Vector2(100, 100)
	heldItem = null

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
func pickUpBox ():
	return null
	


func _on_box_1_body_entered(body):
	pass # Replace with function body.
