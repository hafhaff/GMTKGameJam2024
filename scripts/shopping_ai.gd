extends CharacterBody2D

class_name ShoppingAI

@export var speed: float = 100
@export var shelfHolder: Node
@export var counterHolder: Node

@onready var shoppingTimer: Timer = $Timer
@onready var navigation: NavigationAgent2D = $NavigationAgent2D

var target: Node2D = null
var itemsNeeded: int = 0
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
		if target == null:
			return
		itemsHeld += 1
		target = null
		shoppingTimer.start(1.5)
		return
	
	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	move_and_slide()

func _generateTarget():
	if itemsHeld < itemsNeeded:
		target = shelves.pick_random()
	else:
		target = counters.pick_random()
		itemsNeeded = randi_range(1,3)
		itemsHeld = 0

	navigation.target_position = target.global_position