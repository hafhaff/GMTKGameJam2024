extends CharacterBody2D

class_name Player

@export var speed: float = 100
@export var pickUpCoolDown = 0.3
@export var zoom_min = Vector2(0.5000001, 0.5000001)
@export var zoom_max = Vector2(6.0000001, 6.0000001)

var heldItem : Node
var counter: Counter
var heldItemNum
var canUnload

var zoom_speed = Vector2(0.3000001, 0.3000001)

@onready var camera = $Camera2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay

func _ready():
	position = Vector2(100, 100)
	heldItem = null
	kittyDisplay.randomize_look()

func _physics_process(_delta):
	var action1 = Input.is_action_just_pressed("Action1")
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if not direction.x == 0:
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
	

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if camera.zoom > zoom_min:
					camera.zoom -= zoom_speed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if camera.zoom < zoom_min:
					camera.zoom += zoom_speed
	pass
	
