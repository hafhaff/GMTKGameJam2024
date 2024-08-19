extends Control

@export var boxSpriteAtlas: AtlasTexture = null
@export var gridContainer: GridContainer = null
@export var shoppingUiItem: PackedScene = null
@export var hiringMenu: Node
@export var constructionMenu: Node

var itemGlobalLocal = ItemGlobal.new()
var orderedTypes: Array[ItemGlobal.FoodTypes]
var orderTotal: int = 0
var showPos: Vector2 = Vector2(0, 0)
var hidePos: Vector2 = Vector2(0, -720)
var isHidden: bool = false

@onready var totalText: Label = $Panel/Control/Total

func _ready():
	_fillUiWithItems()
	_hide()

func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action_pressed('shopping'):
			printt(hiringMenu.visible, constructionMenu.visible)
			if (hiringMenu != null && !hiringMenu.visible) && (constructionMenu != null && !constructionMenu.visible):
				_hide()

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
	if !global_shop._calcNewPrice(-orderTotal):
		return
	global_shop._createBoxes(orderedTypes)
	global_shop._removeKitcoin(orderTotal)
	_clearCart()

func _hide():
	isHidden = !isHidden
	var tweenTheSecond = create_tween()
	tweenTheSecond.set_trans(Tween.TRANS_QUAD)
	tweenTheSecond.set_ease(Tween.EASE_OUT)
	tweenTheSecond.tween_property(self, "position", hidePos if isHidden else showPos, 0.5)