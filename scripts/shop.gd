extends Node

class_name Shop

var shopShelves: Dictionary = {}	#dictionary
var shopCounters: Dictionary = {}	#dictionary

var emptyCounters: Array[Counter] = []
var tileMap: NavmeshUpdater = null
var kitcoins: float = 100.0
var emptyShelves: Array[Shelf] = []
var chunkNum = 1
@onready var boxes: Dictionary = {
	ItemGlobal.FoodTypes.CANNED : [],
	ItemGlobal.FoodTypes.CEREAL : []
}

signal kitcoinUpdated(float)
signal newEmptyShelf(shelf)

func _registerTilemap(_tileMap: NavmeshUpdater):
	tileMap = _tileMap

func _registerShelf(shelf: Shelf):
	var position: Vector2i = floor(shelf.global_position/32)
	shopShelves[position] = shelf
	tileMap._removeNavmeshFromTile(position)

func _registerCounter(counter: Counter):
	var position: Vector2i = floor(counter.global_position/32)
	shopCounters[position] = counter
	_handleEmptyCounter(counter)

func _handleEmptyCounter(counter: Counter, forced: bool = false):
	if forced:
		if !emptyCounters.has(counter):
			emptyCounters.push_back(counter)
			return
	if !emptyCounters.has(counter):
		emptyCounters.push_back(counter)
	else:
		emptyCounters.erase(counter)

func _handleEmptyShelf(shelf: Shelf):
	if shelf.itemNum > 0:
		if emptyShelves.has(shelf):
			emptyShelves.erase(shelf)
		return
	
	if emptyShelves.has(shelf):
		emptyShelves.erase(shelf)
	else:
		emptyShelves.push_back(shelf)
		newEmptyShelf.emit(shelf)

func _addBox(_box: box):
	if !boxes[_box.itemType].has(_box):
		boxes[_box.itemType].push_back(_box)
		_box.connect("selfYeet", _removeBox)
		_box.connect("pickUp", _removeBox)

func _removeBox(_box: box):
	if boxes[_box.itemType].has(_box):
		boxes[_box.itemType].erase(_box)

func _handleBoxPickup(_box: box, pickedUp: bool):
	#In our list, but picked up, we remove from our list
	if boxes[_box.itemType].has(_box) && pickedUp:
		boxes[_box.itemType].erase(_box)
	#Not in our list, but dropped, we add to our list
	elif !boxes[_box.itemType].has(_box) && !pickedUp:
		boxes[_box.itemType].push_back(_box)

func _addKitcoin(addition: float):
	kitcoins += addition
	kitcoinUpdated.emit(kitcoins)

func _removeKitcoin(addition: float):
	kitcoins -= addition
	kitcoinUpdated.emit(kitcoins)
	
func getKitcoin():
	return kitcoins

func addChunkNum(num):
	chunkNum += num
	
