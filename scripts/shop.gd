extends Node

class_name Shop

var shopShelves: Dictionary = {}	#dictionary
var shopCounters: Dictionary = {}	#dictionary

var emptyCounters: Array[Counter] = []

func _registerShelf(shelf: Shelf):
	var position: Vector2i = floor(shelf.global_position/32)
	shopShelves[position] = shelf

func _registerCounter(counter: Counter):
	var position: Vector2i = floor(counter.global_position/32)
	shopCounters[position] = counter

func _handleEmptyCounter(counter: Counter):
	if counter.counterEmpty:
		emptyCounters.push_back(counter)
	else:
		emptyCounters.erase(counter)