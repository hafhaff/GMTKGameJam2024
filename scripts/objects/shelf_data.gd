extends Node2D

class_name Shelf

var maxItemCount = 12
@export var itemNum = 0
@export var itemType: ItemGlobal.FoodTypes
@export var supportedItems: Array = [ItemGlobal.FoodTypes.CANNED]
@export var optionalAutoFill: bool = false
var location
var isToolTipActive = false

var interactPos: Vector2
@onready var shelved_items: ShelvedItems = $ShelvedItems
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("shelf ready")
	if optionalAutoFill:
		fillWithRandom()	#For debugging n stuff, remove later
	global_position = floor(global_position/32)*32	#Important for the tilemap, BUT we'll handle placement differently later
	global_shop._registerShelf(self)	#Important, don't remove
	interactPos = $InteractPos.global_position
	$ShelvedItems.updateStockSprite()
	global_shop._handleEmptyShelf(self)
	shelved_items.update_product_type(itemType)
	shelved_items.updateStockSprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func getSpaceLeft():
	return maxItemCount - itemNum

# Check if item is supported
func is_supported(itemType) -> bool:
	var is_supporting: bool = false
	
	for i in supportedItems.size():
		if itemType == supportedItems[i]:
			is_supporting = true
	
	return is_supporting

func fill(numItems, itemType) -> int:
	var remainingItems = numItems
	
	if self.itemNum <= 0:
		# If there's 0 items, ignore item type
		self.itemType = itemType
		
		var itemsToBeAdded
		
		self.itemNum += remainingItems
		if self.itemNum > maxItemCount:
			remainingItems += self.itemNum - maxItemCount
		remainingItems -= self.itemNum
			
		# Set visuals
		shelved_items.update_product_type(itemType)
		$ShelvedItems.updateStockSprite()
		
		# This will be used for logic handled by the player/AI
		
	elif itemType == self.itemType:
		if getSpaceLeft() < remainingItems:
			
			remainingItems -= getSpaceLeft()
			
			self.itemNum = maxItemCount
			global_shop._handleEmptyShelf(self)
			$ShelvedItems.updateStockSprite()
		else:
			self.itemNum += remainingItems
			remainingItems = 0
			
			global_shop._handleEmptyShelf(self)
			$ShelvedItems.updateStockSprite()
	
	update_tooltip()
	return remainingItems
		
#use 1 as num  items taken if you want one at a time
func take(numItemsTaken, itemType): 
	if itemType == self.itemType:
		if numItemsTaken <= self.itemNum:
			self.itemNum -= numItemsTaken
			$ShelvedItems.updateStockSprite()
			global_shop._handleEmptyShelf(self)
			update_tooltip()
			return true
		else:
			self.itemNum = 0
			global_shop._handleEmptyShelf(self)
			$ShelvedItems.updateStockSprite()
			update_tooltip()
			return false
	else: 
		$ShelvedItems.updateStockSprite()
		update_tooltip()
		return false

# For players to take items
func takeFromShelf(numItemsWanted) -> int: 
	var itemsToGive: int = 0
	
	# May need to remember to change this if the standard for max items per box is changed
	var maxItemsInBox: int = 10
	
	if numItemsWanted <= self.itemNum:
		self.itemNum -= numItemsWanted
		itemsToGive = numItemsWanted
		$ShelvedItems.updateStockSprite()
		global_shop._handleEmptyShelf(self)
	elif numItemsWanted == self.itemNum:
		itemsToGive = self.itemNum
		self.itemNum = 0
		global_shop._handleEmptyShelf(self)
		$ShelvedItems.updateStockSprite()
	else:
		itemsToGive = self.itemNum
		self.itemNum = 0
		global_shop._handleEmptyShelf(self)
		$ShelvedItems.updateStockSprite()
	
	update_tooltip()
	
	return itemsToGive

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
	itemType = supportedItems.pick_random() as ItemGlobal.FoodTypes
	itemNum = maxItemCount

func _on_interact_shape_body_entered(body):
	if body is Player:
		body.interaction_manager.register_area(self)
	#	body.canUnload = true
	#	body.curShelf = self
	#	setup_tooltip(true, position + Vector2(-13, -24))

func _on_interact_shape_body_exited(body):
	if body is Player:
		body.interaction_manager.unregister_area(self)
	#		body.canUnload = false
	#		body.curShelf = null
	#		setup_tooltip(false)

func update_tooltip():
	if isToolTipActive:
		setup_tooltip(true, position + Vector2(-13, -24))

func setup_tooltip(switch: bool, positionArg: Vector2 = Vector2.ZERO):
	
	# Only perform actions if the tooltip exists to prevent crashes
	if global_shop.storageUnitTooltip != null:
		print("found tooltip")
		var tooltip: StorageTooltip = global_shop.storageUnitTooltip
		tooltip.global_position = positionArg
		tooltip.visible = switch
		tooltip.set_tooltip_display(self.itemType, self.itemNum, self.maxItemCount)
		isToolTipActive = switch
	else:
		print("didnt find tooltip")
