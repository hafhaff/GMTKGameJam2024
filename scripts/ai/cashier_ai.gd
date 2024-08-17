extends CharacterBody2D

@export var speed: float = 100

var target: Counter = null
var lookForCounterTimer: Timer = Timer.new()
var jobTimer: Timer = Timer.new()

@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var kittyDisplay: KittyDisplay = $KittyDisplay

func _ready():
	add_child(lookForCounterTimer)
	lookForCounterTimer.one_shot = true
	lookForCounterTimer.connect("timeout", _lookForJob)
	lookForCounterTimer.start(3)
	add_child(jobTimer)
	jobTimer.one_shot = true
	jobTimer.connect("timeout", _jobInteract)

func _physics_process(_delta):
	if navigation.is_navigation_finished():
		kittyDisplay.is_walking = false
		if target == null:
			return
		jobTimer.start(1)
		set_physics_process(false)
		return
	
	var nextPos: Vector2 = navigation.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	kittyDisplay.is_flipped = velocity.x < 0
	move_and_slide()

func _lookForJob():
	if global_shop.emptyCounters.size() == 0:
		lookForCounterTimer.start(3)
		return
	
	target = global_shop.emptyCounters[0]
	global_shop._handleEmptyCounter(global_shop.emptyCounters[0])
	navigation.target_position = target.cashierPos

func _jobInteract():
	target._checkShopperDistance()
	jobTimer.start(1)