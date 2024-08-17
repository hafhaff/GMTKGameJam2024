extends Node

class_name Shop

var shopShelves: Dictionary = {}	#dictionary
var shopCounters: Dictionary = {}	#dictionary

func _registerShelf(shelf: Shelf):
	var position: Vector2i = floor(shelf.global_position/32)
	shopShelves[position] = shelf

func _registerCounter(shelf: Counter):
	var position: Vector2i = floor(shelf.global_position/32)
	shopCounters[position] = shelf