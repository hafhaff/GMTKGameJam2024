extends Node

@export var shoppingAI: PackedScene = null
@export var maxShoppers: int = 10

var activeShoppers: int = 0
var lifetimeSpawns: int = 0

@onready var spawnTimer: Timer = $"Spawn Timer"

func _ready():
	spawnTimer.start(3)

func _on_spawn_timer_timeout():
	if activeShoppers >= maxShoppers:
		return

	var shopper: ShoppingAI = shoppingAI.instantiate()
	add_child(shopper)
	activeShoppers += 1
	spawnTimer.start(10 + (2 * (activeShoppers/maxShoppers) * 10))
	shopper.navigation.avoidance_priority = lifetimeSpawns
	lifetimeSpawns += 1
	shopper.connect("leavingShop", _catExit)

func _catExit(cat: ShoppingAI):
	cat.disconnect("leavingShop", _catExit)
	activeShoppers -= 1