extends CharacterBody2D

class_name Player

@export var speed: float = 150
@export var pickUpCoolDown = 0.3
@export var zoom_min = Vector2(2.00001, 2.00001)
@export var zoom_max = Vector2(5.00001, 5.00001)

var heldItem : Node
var counter: Counter
var heldItemNum
var canUnload
var curShelf : Shelf = null

var zoom_speed = Vector2(0.300001, 0.300001)

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
	if action1 and canUnload:
		fillShelf()

func fillShelf():
	print("filling shelf")
	if canUnload and heldItem is box:
		print("items in box before fill:")
		print(getNumInBox())
		print("items in shelf:")
		print(curShelf.itemNum)
		var itemsToPutIn = curShelf.maxItemCount-curShelf.itemNum
		curShelf.fill(getNumInBox(), getBoxItem())
		
		if curShelf.itemType != getBoxItem():
			pass
		
		else: 
			if getNumInBox() <= itemsToPutIn:
				deleteEmptyBox()
			else:
				print("items in box after fill:")
				setNumInBox(getNumInBox()-itemsToPutIn)
				print(getNumInBox())

func getShelf(shelf):
	return shelf
	
func setNumInBox(num):
	heldItem.itemNum = num

func getNumInBox():
	if heldItem != null:
		return heldItem.itemNum
	
func getBoxItem():
	if heldItem != null:
		return heldItem.itemType

func deleteEmptyBox():
	$HoldBox.visible = false
	heldItem.queue_free()
	heldItem = null

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
	if event is InputEventMouseButton or Input:
		if event.is_pressed():
			if event.is_action_pressed('zoom_out'):
				if camera.zoom > zoom_min:
					camera.zoom -= zoom_speed
			if event.is_action_pressed('zoom_in'):
				if camera.zoom < zoom_max:
					camera.zoom += zoom_speed
				
	
