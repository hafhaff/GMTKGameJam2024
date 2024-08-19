extends Node

@export var boxSpriteAtlas: AtlasTexture = null
@export var gridContainer: GridContainer = null
@export var shoppingUiItem: PackedScene = null

var itemGlobalLocal = ItemGlobal.new()
var orderedTypes: Array[ItemGlobal.FoodTypes]
var orderTotal: int = 0

@onready var totalText: Label = $Panel/Control/Total

func _ready():
	_fillUiWithItems()

func _fillUiWithItems():
	for itemID in itemGlobalLocal.FoodTypes.size():
		var shoppingItem: HBoxContainer = shoppingUiItem.instantiate()
		gridContainer.add_child(shoppingItem)
		shoppingItem.get_child(0).texture = boxSpriteAtlas
		shoppingItem.get_child(0).texture.region.size = Vector2(32,32)
		#shoppingItem.get_child(0).texture.region.position = Vector2(itemID * 32, 0)
		shoppingItem.get_child(1).text = str(ItemGlobal.FoodTypes.keys()[itemID])
		shoppingItem.get_child(2).text = str(itemGlobalLocal.FoodValues[itemID].purchasePrice)
		shoppingItem.get_child(3).text = str(itemGlobalLocal.FoodValues[itemID].sellPrice)
		shoppingItem.get_child(4).connect("pressed", _addToCart.bind(itemID, itemGlobalLocal.FoodValues[itemID].purchasePrice))

func _addToCart(type: ItemGlobal.FoodTypes, price: int):
	var multiplier = 10 if Input.is_key_pressed(KEY_SHIFT) else 1
	multiplier = 100 if Input.is_key_pressed(KEY_CTRL) else multiplier
	multiplier = 1000 if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_SHIFT) else multiplier
	orderTotal += price * multiplier
	totalText.text = str(orderTotal)
	for x in range(multiplier):
		orderedTypes.push_back(type)
	print(orderedTypes.size())

func _clearCart():
	orderTotal = 0
	totalText.text = str(orderTotal)
	orderedTypes.clear()

func _submit():
	pass