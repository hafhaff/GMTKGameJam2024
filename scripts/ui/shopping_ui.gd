extends Control

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
@onready var autoBuyTimer: Timer = $Timer

func _ready():
	_fillUiWithItems()
	_hide()
	autoBuyTimer.connect("timeout", _autoBuyBoxes)
	for type in range(ItemGlobal.FoodTypes.size()):
		_setAutoBuy(1, type)

func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action_pressed('shopping'):
			_hide()

func _fillUiWithItems():
	for itemID in itemGlobalLocal.FoodTypes.size():
		var shoppingItem: HBoxContainer = shoppingUiItem.instantiate()
		gridContainer.add_child(shoppingItem)
		shoppingItem.get_child(0).texture.region.position = Vector2(itemID * 32, 0)
		#print(shoppingItem.get_child(0).texture.region.position)
		shoppingItem.get_child(1).text = GlobalTipsHelper.item_names[itemID]
		shoppingItem.get_child(2).text = str(itemGlobalLocal.FoodValues[itemID].purchasePrice)
		shoppingItem.get_child(3).text = str(itemGlobalLocal.FoodValues[itemID].sellPrice)
		shoppingItem.get_child(4).connect("pressed", _addToCart.bind(itemID, itemGlobalLocal.FoodValues[itemID].purchasePrice))
		shoppingItem.get_child(5).connect("value_changed", _setAutoBuy.bind(itemID))

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
	if isHidden:
		if hiringMenu != null && hiringMenu.visible:
			hiringMenu._toggleDisplay()
		if constructionMenu != null && constructionMenu.visible:
			constructionMenu._toggleDisplay()
	isHidden = !isHidden
	var tweenTheSecond = create_tween()
	tweenTheSecond.set_trans(Tween.TRANS_QUAD)
	tweenTheSecond.set_ease(Tween.EASE_OUT)
	tweenTheSecond.tween_property(self, "position", hidePos if isHidden else showPos, 0.5)

func _setAutoBuy(newText: float, itemID: int):
	global_shop._boxAutoBuy(itemID, newText)

func _autoBuyBoxes():
	for type in global_shop.autoBuyBoxes:
		if !global_shop.boxes.has(type):
			for i in range(global_shop.autoBuyBoxes[type]):
				orderTotal += itemGlobalLocal.FoodValues[type].purchasePrice
				orderedTypes.push_back(type)
			continue
		if global_shop.boxes[type].size() < global_shop.autoBuyBoxes[type]:
			for i in range(global_shop.boxes[type].size(), global_shop.autoBuyBoxes[type]):
				orderTotal += itemGlobalLocal.FoodValues[type].purchasePrice
				orderedTypes.push_back(type)
	_submit()
