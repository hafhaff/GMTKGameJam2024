extends Node

@export var shoppingAI: PackedScene = null
@export var maxShoppers: int = 10
@export var cameraSwitching: bool = false

var activeShoppers: Array[ShoppingAI] = []
var lifetimeSpawns: int = 0

@onready var spawnTimer: Timer = $"Spawn Timer"
@onready var cameraSwitchingTimer: Timer = $"Camera Switch Timer"

func _ready():
	spawnTimer.start(3)
	if cameraSwitching:
		cameraSwitchingTimer.start(3)

func _on_spawn_timer_timeout():
	if activeShoppers.size() >= maxShoppers:
		return

	var shopper: ShoppingAI = shoppingAI.instantiate()
	add_child(shopper)
	activeShoppers.push_back(shopper)
	spawnTimer.start((1 if cameraSwitching else 10) + (2 * (float(activeShoppers.size())/maxShoppers) * 10))
	lifetimeSpawns += 1
	shopper.connect("leavingShop", _catExit)
	if cameraSwitching:
		var camera: Camera2D = Camera2D.new()
		shopper.add_child(camera)
		shopper.attachedCamera = camera
		camera.zoom = Vector2(3,3)

func _catExit(cat: ShoppingAI):
	cat.disconnect("leavingShop", _catExit)
	activeShoppers.erase(cat)

func _switchCamera():
	print("Camera Switch")
	activeShoppers.pick_random().attachedCamera.make_current()
