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
	lookForEmptyShelf.start(randf_range(1,4))

func _physics_process(_delta):
	if target == null:
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
		if global_shop.boxes[type].size() != 0:
			_boxes = global_shop.boxes[type]
			break
	if _boxes.size() == 0:
		shelf = null
		return false
	_boxes.shuffle()
	target = _boxes[0]
	target.connect("pickedUp", _lostTarget)
	navigation.target_position = target.global_position
	global_shop._handleEmptyShelf(shelf)
	return true

func _lostTarget(_box: Box, _pickedUp: bool):
	print("Lost target")
	target.disconnect("pickedUp", _lostTarget)
	if !navigation.is_navigation_finished():
		global_shop._handleEmptyShelf(shelf)
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
	heldItem.position = self.global_position
	heldItem.show()
	heldItem.pickUpCoolDown()
