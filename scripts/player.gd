extends CharacterBody2D

@export var speed: float = 100
@export var pickUpCoolDown = 0.3

var heldItem : Node
var heldItemNum
var canUnload

func _ready():
	position = Vector2(100, 100)
	heldItem = null

func _physics_process(_delta):
	var action1 = Input.is_action_just_pressed("Action1")
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	if action1:
		print(self.global_position)
		dropBox()


	
func dropBox():
	if heldItem == null: 
		pass
	else: 
		heldItem.disablePickup()
		heldItem.position = self.global_position
		print (heldItem.position)
		heldItem.show()
		heldItem.pickUpCoolDown()
		heldItem = null
		print("dropping")
		

func pickUpBox (box):
	box.hideSprite()
	box.disablePickup()
	heldItem = box
	print(heldItem.getName())
	
