extends Node

class_name Shop

var shopShelves: Dictionary = {}	#dictionary
var shopCounters: Dictionary = {}	#dictionary

var emptyCounters: Array[Counter] = []
var tileMap: NavmeshUpdater = null
var kitcoins: float = 100.0

signal kitcoinUpdated(float)

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

func _addKitcoin(addition: float):
	kitcoins += addition
	kitcoinUpdated.emit(kitcoins)

func _removeKitcoin(addition: float):
	kitcoins -= addition
	kitcoinUpdated.emit(kitcoins)
	
func getKitcoin():
	return kitcoins
	
