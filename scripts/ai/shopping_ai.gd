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

func _ready():
	shoppingTimer.connect("timeout", _generateTarget)
	shelves = shelfHolder.get_children()
	counters = counterHolder.get_children()
	_generateTarget()

func _process(_delta):
	if navigation.is_navigation_finished():
		kittyDisplay.is_walking = false
		if target == null:
			return
		itemsHeld += 1
		target = null
		shoppingTimer.start(1.5)
		return
	
	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	if velocity.x > 0:
		kittyDisplay.is_flipped = false
	else:
		kittyDisplay.is_flipped = true
	move_and_slide()

func _generateTarget():
	if itemsHeld < itemsNeeded:
		target = shelves.pick_random()
		if target == null:
			shoppingTimer.start(10)
			return
	else:
		target = counters.pick_random()
		itemsNeeded = randi_range(1,3)
		itemsHeld = 0
		itemType = randi_range(0, ItemGlobal.FoodTypes.size() - 1) as ItemGlobal.FoodTypes

	kittyDisplay.is_walking = true
	navigation.target_position = target.global_position

func _selectShelf() -> Shelf:
	for shelf in shelves:
		if shelf.itemType == itemType:
			return shelf
	
	return null