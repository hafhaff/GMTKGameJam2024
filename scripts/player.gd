extends CharacterBody2D

class_name Player

@export var speed: float = 150
@export var pickUpCoolDown = 0.3
@export var zoom_min = Vector2(2.00001, 2.00001)
@export var zoom_max = Vector2(5.00001, 5.00001)
@export var box_scene: PackedScene = null

var heldItem : Node
var counter: Counter
var heldItemNum
var canUnload
var curShelf: Shelf = null

var zoom_speed = Vector2(0.300001, 0.300001)

@onready var camera = $Camera2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay

func _ready():
	position = Vector2(100, 100)
	heldItem = null
	kittyDisplay.randomize_look()
	kittyDisplay.set_role(kittyDisplay.KittyRole.PLAYER)

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
	if action1 and canUnload and getNumInBox() > 0:
		fillShelf()
	elif action1 and canUnload and getNumInBox() < 1:
		takeShelf()
	

func fillShelf():
	print("filling shelf")
	if canUnload and heldItem is Box and curShelf.is_supported(getBoxItem()):
		#You can use printt instead or print ~Hullahopp
		print("items in Box before fill:", getNumInBox())
		print("items in shelf:", curShelf.itemNum)
		
		var remianingItems = curShelf.fill(getNumInBox(), getBoxItem())
		
		print("items in Box after fill:", remianingItems)
		
		if remianingItems == getNumInBox():
			print("Fill attempt failed")
		elif remianingItems > 0:
			setNumInBox(remianingItems)
			print("Success, partial fill")
		else:
			deleteEmptyBox()
			print("Success, complete fill")
	
	print(curShelf.is_supported(getBoxItem()))

func takeShelf():
	
	var numItemsTaken = curShelf.takeFromShelf(10)
	
	if numItemsTaken > 0:
		var newBox = box_scene.instantiate()
		get_tree().root.get_child(1).add_child(newBox)
		pickUpBox(newBox)
		
		heldItem.itemType = curShelf.itemType
		$HoldBox.update_box_type(heldItem.itemType)
		setNumInBox(numItemsTaken)

func getShelf(shelf):
	return shelf
	
func setNumInBox(num):
	heldItem.itemNum = num

func getNumInBox():
	if heldItem != null:
		return heldItem.itemNum
	else:
		return 0
	
func getBoxItem():
	if heldItem != null:
		return heldItem.itemType

func deleteEmptyBox():
	$HoldBox.visible = false
	heldItem.removeSelf()
	heldItem = null

func dropBox():
	if heldItem == null: 
		pass
	else: 
		$HoldBox.visible = false
		heldItem.disablePickup()
		heldItem.global_position = self.global_position
		print (heldItem.position)
		heldItem.showSprite()
		heldItem.pickUpCoolDown()
		heldItem = null
		print("dropping")
		

func pickUpBox (box: Box):
	heldItem = box
	$HoldBox.update_box_type(getBoxItem())
	$HoldBox.visible = true
	box.hideSprite()
	box.disablePickup()
	
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
				
	
