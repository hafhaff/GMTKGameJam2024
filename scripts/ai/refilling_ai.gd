extends CharacterBody2D

class_name RefillingAI

@export var speed: float = 100

var target: Node2D = null
var shelf: Shelf = null
var heldItem: Box = null

@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay
@onready var lookForEmptyShelf: Timer = $SearchTimer
@onready var boxHoldSprite: BoxDisplay = $HoldBox

var wage = global_shop.prices["restocker"]

func _ready():
	kittyDisplay.randomize_look()
	kittyDisplay.set_role(kittyDisplay.KittyRole.RESTOCKER)
	#global_shop.connect("newEmptyShelf", _setShelf)
	lookForEmptyShelf.start(randf_range(1,4))

func _physics_process(_delta):
	if target == null || !is_instance_valid(target):
		if shelf != null:
			printerr("No target (box), but we have a shelf set! Box got freed? Resetting...")
			shelf = null
		kittyDisplay.is_walking = false
		return
	if navigation.is_navigation_finished():
		kittyDisplay.is_walking = false
		if heldItem == null:
			_pickupBox()
		else:
			_fillShelf()

	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	kittyDisplay.is_flipped = velocity.x < 0
	kittyDisplay.is_walking = true
	move_and_slide()

func _lookForShelf():
	printt("Looking for shelf", self, shelf)
	if shelf != null:
		return
	for _shelf in global_shop.emptyShelves:
		if _setShelf(_shelf):
			return

func _setShelf(_shelf: Shelf) -> bool:
	if shelf != null:
		return true
	
	shelf = _shelf
	var validTypes = shelf.supportedItems.duplicate()
	validTypes.shuffle()
	var _boxes: Array =  []
	for type in validTypes:
		if !global_shop.boxes.has(type):
			continue
		if global_shop.boxes[type].size() != 0:
			_boxes = global_shop.boxes[type].duplicate()
			break
	if _boxes.size() == 0:
		shelf = null
		return false
	_boxes.shuffle()
	if !is_instance_valid(_boxes[0]):
		shelf = null
		global_shop._boxCleanup()
		return false
	target = _boxes[0]
	target.connect("pickedUp", _lostTarget)
	navigation.target_position = target.global_position
	global_shop._handleEmptyShelf(shelf, true)
	return true

func _lostTarget(_box: Box, _pickedUp: bool):
	#print("Lost target")
	target.disconnect("pickedUp", _lostTarget)
	if !navigation.is_navigation_finished():
		global_shop._handleEmptyShelf(shelf, true)
		shelf = null
		target = null

func _pickupBox():
	target.disconnect("pickedUp", _lostTarget)
	boxHoldSprite.visible = true
	target.hideSprite()
	target.disablePickup()
	heldItem = target
	boxHoldSprite.update_box_type(heldItem.itemType)
	navigation.target_position = shelf.interactPos

func _fillShelf():
	if shelf.itemType != heldItem.itemType && shelf.itemNum > 0:
		_dropItem()
		heldItem = null
		target = null
		shelf = null
		return

	var rem: int = shelf.fill(heldItem.itemNum, heldItem.itemType)
	if rem <= 0:
		_deleteEmptyBox()
	else:
		heldItem.itemNum -= rem
		_dropItem()
	heldItem = null
	target = null
	shelf = null

func _deleteEmptyBox():
	boxHoldSprite.visible = false
	target.removeSelf()

func _dropItem():
	boxHoldSprite.visible = false
	heldItem.disablePickup()
	heldItem.global_position = self.global_position
	heldItem.update_box_type()
	heldItem.showSprite()
	heldItem.pickUpCoolDown()

func payWage():
	global_shop.buy(wage)
	pass

func _on_timer_timeout():
	payWage()
	pass # Replace with function body.
