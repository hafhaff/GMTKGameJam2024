extends Node

class_name Shop

var shopShelves: Dictionary = {}	#dictionary
var shopCounters: Dictionary = {}	#dictionary

var emptyCounters: Array[Counter] = []
var tileMap: NavmeshUpdater = null
var kitcoins: float = 100.0
var emptyShelves: Array[Shelf] = []
var chunkNum = 1
@onready var boxes: Dictionary = {}

var topLeft = Vector2i(0,0)
var topRight = Vector2i(9,0)
var bottomLeft = Vector2i(0,9)
var bottomRight = Vector2i(9,9)

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

func _addBox(box: Box):
	if !boxes.has(box.itemType):
		boxes[box.itemType] = []
	if !boxes[box.itemType].has(box):
		boxes[box.itemType].push_back(box)
		box.connect("selfYeet", _removeBox)
		box.connect("pickedUp", _handleBoxPickup)

func _removeBox(box: Box, _pickedUp: bool = false):
	if boxes[box.itemType].has(box):
		boxes[box.itemType].erase(box)

func _handleBoxPickup(box: Box, pickedUp: bool):
	#In our list, but picked up, we remove from our list
	if boxes[box.itemType].has(box) && pickedUp:
		boxes[box.itemType].erase(box)
	#Not in our list, but dropped, we add to our list
	elif !boxes[box.itemType].has(box) && !pickedUp:
		boxes[box.itemType].push_back(box)

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
	
