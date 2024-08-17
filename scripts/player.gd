extends CharacterBody2D

class_name Player

@export var speed: float = 100
@export var pickUpCoolDown = 0.3

var heldItem : Node
var counter: Counter
var heldItemNum
var canUnload

@onready var kittyDisplay: KittyDisplay = $KittyDisplay

func _ready():
	position = Vector2(100, 100)
	heldItem = null
	kittyDisplay.randomize_look()

func _physics_process(_delta):
	var action1 = Input.is_action_just_pressed("Action1")
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	kittyDisplay.is_flipped = velocity.x < 0
	kittyDisplay.is_walking = direction != Vector2.ZERO
	move_and_slide()
	
	if action1 and not canUnload:
		print(self.global_position)
		dropBox()
	if action1 and counter != null:
		counter._checkShopperDistance()

func fillPart():
	pass

func getShelf(shelf):
	return shelf
	
func dropBox():
	if heldItem == null: 
		pass
	else: 
		$HoldBox.visible = false
		heldItem.disablePickup()
		heldItem.position = self.global_position
		print (heldItem.position)
		heldItem.show()
		heldItem.pickUpCoolDown()
		heldItem = null
		print("dropping")
		

func pickUpBox (box):
	$HoldBox.visible = true
	box.hideSprite()
	box.disablePickup()
	heldItem = box
	print(heldItem.getName())
	
