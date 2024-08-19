extends Node2D

class_name StoreEntrance

@export var shoppingAI: PackedScene = null
@export var maxShoppers: int = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var activeShoppers: Array[ShoppingAI] = []
var lifetimeSpawns: int = 0

func _ready() -> void:
	spawn_customer()
	spawn_customer()
	spawn_customer()

func spawn_customer():
	var shopper: ShoppingAI = shoppingAI.instantiate()
	add_child(shopper)
	shopper.global_position = position + Vector2(randf_range(-10, 10), 0)
	activeShoppers.push_back(shopper)
	lifetimeSpawns += 1
	shopper.connect("leavingShop", _catExit)
	animation_player.play("open")

func _catExit(cat: ShoppingAI):
	cat.disconnect("leavingShop", _catExit)
	activeShoppers.erase(cat)
