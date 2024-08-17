extends CharacterBody2D

class_name ShoppingAI

@export var speed: float = 100
@export var shelfHolder: Node
@export var counterHolder: Node

@onready var shoppingTimer: Timer = $Timer
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay

var target: Node2D = null
var itemsNeeded: int = 0
var itemType: ItemGlobal.FoodTypes
var itemsHeld: int = 0
var shelves: Array[Node]
var counters: Array[Node]
var waitForCheckout: bool = true

func _ready():
	shoppingTimer.connect("timeout", _generateTarget)
	shelves = shelfHolder.get_children()
	counters = counterHolder.get_children()
	_generateTarget()
	kittyDisplay.randomize_look()

func _physics_process(_delta):
	if navigation.is_navigation_finished():
		kittyDisplay.is_walking = false
		if waitForCheckout:
			return
		if target == null:
			return
		itemsHeld += 0 if target is Counter else 1
		target = null
		shoppingTimer.start(1.5)
		return
	
	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	kittyDisplay.is_flipped = velocity.x < 0
	move_and_slide()

#Temporary, will get refactored when the shop is finished
func _generateTarget():
	printt("kitty ", itemsHeld, itemsNeeded)
	if itemsHeld < itemsNeeded:
		target = _selectShelf()
		if target == null:
			shoppingTimer.start(3)
			return
	else:
		target = _selectClosestCounter()
		if target == null:
			shoppingTimer.start(3)
			return
		waitForCheckout = true
		target._addToWaitList(self)
		itemsNeeded = randi_range(1,3)
		itemsHeld = 0
		itemType = randi_range(0, ItemGlobal.FoodTypes.size() - 1) as ItemGlobal.FoodTypes

	kittyDisplay.is_walking = true
	navigation.target_position = target.interactPos

func _selectShelf() -> Shelf:
	for shelf in global_shop.shopShelves:
		if global_shop.shopShelves[shelf].itemType == itemType:
			return global_shop.shopShelves[shelf]
	
	return null

func _selectClosestCounter():
	if global_shop.shopCounters.size() == 0:
		return null
	
	var _counters: Array = global_shop.shopCounters.values()
	if _counters.size() == 1:
		return _counters[0]
	_counters.sort_custom(func(a, b): return global_position.distance_squared_to(a.global_position) > global_position.distance_squared_to(b.global_position))
	return _counters[0]

func _checkout():
	waitForCheckout = false