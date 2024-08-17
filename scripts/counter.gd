extends Node2D

class_name Counter

var waitList: Array[ShoppingAI]

@onready var checkoutAutoTimer: Timer = Timer.new()

func _ready():
	add_child(checkoutAutoTimer)
	checkoutAutoTimer.one_shot = false
	checkoutAutoTimer.connect("timeout", _checkShopperDistance)
	checkoutAutoTimer.start(3)

func _addToWaitList(shoppingAI: ShoppingAI):
	waitList.push_back(shoppingAI)

func _checkShopperDistance():
	if waitList.size() == 0:
		return
	
	if global_position.distance_squared_to(waitList[0].global_position) < 100:
		waitList[0]._checkout()
		waitList.remove_at(0)