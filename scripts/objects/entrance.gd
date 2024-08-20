extends Node2D

class_name StoreEntrance

@export var shoppingAI: PackedScene = null
@export var maxShoppers: int = 25
var readyToSpawn = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var random_spawns: Timer = $RandomSpawns

var activeShoppers: Array[ShoppingAI] = []
var lifetimeSpawns: int = 0
var customersToSpawn: int = 0
var lifetimeWaves: int = 1

func spawn_customer():
	if activeShoppers.size() >= (maxShoppers * global_shop.chunkNum):
		return
	customersToSpawn -= 1
	play_animation()
	var shopper: ShoppingAI = shoppingAI.instantiate()
	add_child(shopper)
	shopper.global_position = position + Vector2(randf_range(-10, 10), 0)
	activeShoppers.push_back(shopper)
	lifetimeSpawns += 1
	shopper.connect("leavingShop", _catExit)
	

func play_animation():
	animation_player.play("RESET")
	animation_player.play("open")

func _catExit(cat: ShoppingAI):
	cat.disconnect("leavingShop", _catExit)
	activeShoppers.erase(cat)
	play_animation()

func spawn_wave_chunk():
	if customersToSpawn > 2:
		for i in randi_range(1, 3):
			spawn_customer()
			

func _on_timer_timeout() -> void:
	if customersToSpawn > 0:
		if customersToSpawn > 3:
			spawn_wave_chunk()
		else:
			spawn_customer()

func _on_random_spawns_timeout() -> void:
	if readyToSpawn == true:
		random_spawns.start(randi_range(4, 10))
		#Random spaws should be consistent, but increased by shop size, not lifetime spawns ~Hullahopp
		#customersToSpawn += 12 *  round(lifetimeSpawns/5)
		customersToSpawn += 2 *  global_shop.chunkNum

func _on_next_wave_timer_timeout() -> void:
	#print("total spawns::")
	#print(lifetimeSpawns)
	random_spawns.start(randi_range(25, 180))
	#Waves should be multiplied by lifetime waves, otherwise the size grows unexpectedly out of control
	#customersToSpawn += 50 * round(lifetimeSpawns/5)
	customersToSpawn += 20 * lifetimeWaves
	lifetimeWaves += 1


func _on_initial_timer_timeout():
	readyToSpawn = true
	customersToSpawn += 5
	#print("HERE THEY COME")
	pass # Replace with function body.
