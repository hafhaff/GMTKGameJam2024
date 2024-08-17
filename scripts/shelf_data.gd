extends Node

class_name Shelf

var itemNum
var itemName
var location

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#ONLY USE TO REPLACE
func setItem(newItem): 
	itemName = newItem
	
func addItems (num):
	itemNum += num
	
func replaceItem (item, num):
	itemNum = num
	itemName = itemName
		
	
	
