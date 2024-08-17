extends Node2D

class_name Counter

var waitList: Array[ShoppingAI]
var counterEmpty: bool = true

func _ready():
	global_shop._registerCounter(self)

func _addToWaitList(shoppingAI: ShoppingAI):
	waitList.push_back(shoppingAI)

#Called by the Player or AI
func _checkShopperDistance():
	if waitList.size() == 0:
		return
	
	if global_position.distance_squared_to(waitList[0].global_position) < 100:
		waitList[0]._checkout()
		waitList.remove_at(0)

func _changeEmptyState(isEmpty: bool):
	counterEmpty = isEmpty
	global_shop._handleEmptyCounter(self)

func _on_body_entered(body):
	if body is Player:
		_changeEmptyState(false)
		if body.counter != self:
			body.counter = self

func _on_body_exited(body):
	if body is Player:
		_changeEmptyState(true)
		if body.counter == self:
			body.counter = null