extends CharacterBody2D

class_name RefillingAI

@export var speed: float = 100

var target: Node2D = null
var shelf: Shelf = null
var heldItem: Box = null

@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay
@onready var lookForEmptyShelf: Timer = $SearchTimer
@onready var boxHoldSprite: Sprite2D = $HoldBox

func _ready():
	kittyDisplay.randomize_look()
	kittyDisplay.set_role(kittyDisplay.KittyRole.RESTOCKER)
	global_shop.connect("newEmptyShelf", _setShelf)

func _physics_process(_delta):
	if target == null:
		return
	if navigation.is_navigation_finished():
		if heldItem == null:
			_pickupBox()
		else:
			_fillShelf()

	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	kittyDisplay.is_flipped = velocity.x < 0
	move_and_slide()

func _lookForShelf():
	if shelf != null:
		return
	for _shelf in global_shop.emptyShelves:
		if _setShelf(_shelf):
			return

func _setShelf(_shelf: Shelf) -> bool:
	if shelf != null:
		return true
	
	shelf = _shelf
	var _boxes: Array = global_shop.boxes[_shelf.itemType].duplicate()
	if _boxes.size() == 0:
		shelf = null
		return false
	_boxes.shuffle()
	target = _boxes[0]
	target.connect("pickedUp", _lostTarget)
	navigation.target_position = target.global_position
	return true

func _lostTarget(_box: Box, _pickedUp: bool):
	print("Lost target")
	target.disconnect("pickedUp", _lostTarget)
	if !navigation.is_navigation_finished():
		shelf = null
		target = null

func _pickupBox():
	target.disconnect("pickedUp", _lostTarget)
	boxHoldSprite.visible = true
	target.hideSprite()
	target.disablePickup()
	heldItem = target
	navigation.target_position = shelf.interactPos

func _fillShelf():
	var itemsToPutIn = shelf.maxItemCount-shelf.itemNum
	shelf.fill(heldItem.itemNum, heldItem.itemType)
	if heldItem.itemNum <= itemsToPutIn:
		_deleteEmptyBox()
	else:
		print("items in Box after fill:")
		heldItem.itemNum -= -itemsToPutIn
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
	heldItem.position = self.global_position
	heldItem.show()
	heldItem.pickUpCoolDown()
