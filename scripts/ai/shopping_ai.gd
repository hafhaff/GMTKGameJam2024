extends CharacterBody2D

class_name ShoppingAI

@export var speed: float = 100
@export var shelfHolder: Node
@export var counterHolder: Node

@onready var shoppingTimer: Timer = $Timer
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay
@onready var spawnPos: Vector2 = self.global_position
@onready var shelves: Array = global_shop.shopShelves.values().duplicate()

var target: Node2D = null
var shoppingList: Dictionary = {}
var itemsHeld: Dictionary = {}
var itemsTotal: int = 0
var waitForCheckout: bool = false
var attachedCamera: Camera2D	#For the experimental main menu

signal leavingShop(shoppingAI)

func _ready():
	shelves.shuffle()
	shoppingTimer.connect("timeout", _generateTarget)
	_generateShoppingList()
	_generateTarget()
	kittyDisplay.randomize_look()
	kittyDisplay.set_role(KittyDisplay.KittyRole.CUSTOMER)

func _physics_process(_delta):
	if navigation.is_navigation_finished():
		kittyDisplay.is_walking = false
		if navigation.target_position == spawnPos:
			leavingShop.emit(self)
			queue_free()
		if waitForCheckout:
			return
		if target == null:
			return
		if target is Shelf:
			if shoppingList.has(target.itemType):	#shelf item type can change by the time we arrive
				if target.take(1, target.itemType):
					itemsHeld[target.itemType] += 1
		target = null
		shoppingTimer.start(1.5)
		return
	
	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	kittyDisplay.is_flipped = velocity.x < 0
	move_and_slide()

#Temporary, will get refactored when the shop is finished
func _generateTarget():
	if !_shoppingDone():
		target = _selectShelf()
		if target == null:
			printt("Did not find shelf", self, shoppingList, itemsHeld)
			shoppingTimer.start(3)
			return
	else:
		target = _selectShortestCounter()
		if target == null:
			printt("Did not find counter", self, target)
			shoppingTimer.start(3)
			return
		waitForCheckout = true
		target._addToWaitList(self)	#Handles navigation target setting

	kittyDisplay.is_walking = true

func _selectShelf() -> Shelf:
	for item in itemsHeld:
		#if itemsHeld[item] == shoppingList[item]:
		#	continue
		for shelf in shelves:
			if shelf.itemType == item && shelf.itemNum > 0:
				navigation.target_position = shelf.interactPos
				return shelf
	return null

func _selectShortestCounter():
	if global_shop.shopCounters.size() == 0:
		return null
	
	var _counters: Array = global_shop.shopCounters.values()
	if _counters.size() == 1:
		return _counters[0]
	_counters.sort_custom(func(a, b): return a.waitList.size() < b.waitList.size())
	return _counters[0]

func _checkout() -> bool:
	itemsTotal -= 1
	var random_delay = randf_range(-0.5, 0.5)
	play_sound_with_delay(random_delay)
	if itemsTotal < 0:
		waitForCheckout = false
		navigation.target_position = spawnPos
		return true
	return false

func play_sound_with_delay(delay: float) -> void:
	var timer = get_tree().create_timer(delay)
	timer.timeout.connect(self._on_sound_timer_timeout)

func _on_sound_timer_timeout() -> void:
	$purchase.play()
	
func _generateShoppingList():
	itemsTotal = randi_range(1,8)
	for x in range(itemsTotal):
		var key: ItemGlobal.FoodTypes = randi_range(0, ItemGlobal.FoodTypes.size() - 1) as ItemGlobal.FoodTypes
		if shoppingList.has(key):
			shoppingList[key] = shoppingList[key] + 1
		else:
			shoppingList[key] = 1
			itemsHeld[key] = 0

func _shoppingDone() -> bool:
	for key in itemsHeld:
		if itemsHeld[key] != shoppingList[key]:
			return false
	return true
