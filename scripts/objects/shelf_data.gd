extends Node2D

class_name Shelf

var maxItemCount = 12
@export var itemNum = 0
@export var itemType: ItemGlobal.FoodTypes
@export var optionalAutoFill: bool = false
var location

var interactPos: Vector2
@onready var shelved_items: ShelvedItems = $ShelvedItems

# Called when the node enters the scene tree for the first time.
func _ready():
	if optionalAutoFill:
		fillWithRandom()	#For debugging n stuff, remove later
	global_position = floor(global_position/32)*32	#Important for the tilemap, BUT we'll handle placement differently later
	global_shop._registerShelf(self)	#Important, don't remove
	interactPos = $InteractPos.global_position
	shelved_items.update_product_type(itemType)
	shelved_items.updateStockSprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getSpaceLeft():
	return maxItemCount - itemNum

func fill(numItems, itemType):
	if itemType == self.itemType:
		if getSpaceLeft() <= numItems:
			self.itemNum = maxItemCount
			$ShelvedItems.updateStockSprite()
			return true
		else:
			self.itemNum += numItems
			$ShelvedItems.updateStockSprite()
			return true
			
	if self.itemNum == 0:
		self.itemType = itemType
		if getSpaceLeft() <= numItems:
			self.itemNum = maxItemCount
			$ShelvedItems.updateStockSprite()
			return true
		else:
			self.itemNum += numItems
			$ShelvedItems.updateStockSprite()
			return true
	
	else:
		$ShelvedItems.updateStockSprite()
		return false
		
#use 1 as num  items taken if you want one at a time
func take(numItemsTaken, itemType): 
	if itemType == self.itemType:
		if numItemsTaken <= self.itemNum:
			self.itemNum -= numItemsTaken
			$ShelvedItems.updateStockSprite()
			return true
		else:
			self.itemNum = 0
			$ShelvedItems.updateStockSprite()
			return false
	else: 
		$ShelvedItems.updateStockSprite()
		return false

#ONLY USE TO REPLACE with no protection
func setItem(newItem): 
	shelved_items.update_product_type(newItem)
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
		body.curShelf = self
		
	

func _on_interact_shape_body_exited(body):
	if body is Player:
		body.canUnload = false
		body.curShelf = null
