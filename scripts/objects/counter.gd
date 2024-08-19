extends Node2D

class_name Counter

var waitList: Array[ShoppingAI]
var itemGlobalLocal: ItemGlobal = ItemGlobal.new()	#This is retarded

var interactPos: Vector2
var cashierPos: Vector2

@onready var KitcoinAnimate: KitcoinAnimate = $KitcoinAnimate


func _ready():
	global_shop._registerCounter(self)
	global_position = floor(global_position/32)*32	#Important for the tilemap, BUT we'll handle placement differently later
	interactPos = $InteractPos.global_position
	cashierPos = $CashierPos.global_position

func _addToWaitList(shoppingAI: ShoppingAI):
	waitList.push_back(shoppingAI)
	_updateWaitingLine(waitList.size() - 1)

#Called by the Player or AI
func _checkShopperDistance():
	if waitList.size() == 0:
		KitcoinAnimate.checked_out = false
		return
	
	if interactPos.distance_squared_to(waitList[0].global_position) < 100:
		if waitList[0]._checkout():
			var total:float = 0
			for item in waitList[0].shoppingList:
				total += waitList[0].shoppingList[item] * itemGlobalLocal.FoodValues[item].sellPrice
			global_shop._addKitcoin(total)
			KitcoinAnimate.checked_out = true
			print('customer checked out')
			waitList.remove_at(0)
			for x in range(waitList.size()):
				_updateWaitingLine(x)
				
			await get_tree().create_timer(0.1).timeout  # Short delay to ensure animation starts
			KitcoinAnimate.checked_out = false
	

func _changeEmptyState(isEmpty: bool):
	global_shop._handleEmptyCounter(self, isEmpty)

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

func _updateWaitingLine(_position: int):
	printt("updating waiting queue AI position", _position, interactPos + Vector2(-20 * _position, 0))
	waitList[_position].navigation.target_position = interactPos + Vector2(-20 * _position, 0)
