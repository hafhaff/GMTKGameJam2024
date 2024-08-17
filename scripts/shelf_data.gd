extends Node2D

class_name Shelf

var maxItemCount = 12
var itemNum
var itemType: ItemGlobal.FoodTypes
var location


# Called when the node enters the scene tree for the first time.
func _ready():
	fillWithRandom()	#For debugging n stuff, remove later
	global_shop._registerShelf(self)	#Important, don't remove

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

#Need this so I can move forward with the AI. Will be depricated real fast ~Hullahopp
func fillWithRandom():
	itemType = randi_range(0, ItemGlobal.FoodTypes.size() - 1) as ItemGlobal.FoodTypes
	itemNum = maxItemCount

func _on_interact_shape_body_entered(body):
	if body is Player:
		body.canUnload = true
	

func _on_interact_shape_body_exited(body):
	if body is Player:
		body.canUnload = false
