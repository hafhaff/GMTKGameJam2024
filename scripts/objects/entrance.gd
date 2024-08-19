extends Node2D

class_name StoreEntrance

@export var shoppingAI: PackedScene = null
@export var maxShoppers: int = 200

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var random_spawns: Timer = $RandomSpawns

var activeShoppers: Array[ShoppingAI] = []
var lifetimeSpawns: int = 0
var customersToSpawn: int = 0

func spawn_customer():
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
	if customersToSpawn > 0 and activeShoppers.size() < maxShoppers:
		if customersToSpawn > 3:
			spawn_wave_chunk()
		else:
			spawn_customer()

func _on_random_spawns_timeout() -> void:
	random_spawns.wait_time = randi_range(20, 50)
	customersToSpawn += 1

func _on_next_wave_timer_timeout() -> void:
	random_spawns.wait_time = randi_range(60, 180)
	customersToSpawn += 10
