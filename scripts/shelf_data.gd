extends Node

class_name Shelf

var maxItemCount = 12
var itemNum
var itemType: ItemGlobal.FoodTypes
var location


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#ONLY USE TO REPLACE
func setItem(newItem): 
	itemType = newItem
	
func addItems (num):
	itemNum += num
	
func replaceItem (item, num):
	itemNum = num
	itemType = itemType

func _on_interact_shape_body_entered(body):
	if body == $"../../Player":
		$"../../Player".canUnload = true
	

func _on_interact_shape_body_exited(body):
	if body == $"../../Player":
		$"../../Player".canUnload = false
