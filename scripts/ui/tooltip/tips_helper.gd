extends Node

class_name TipsHelper

var storageUnitTooltip: StorageTooltip = null
var controlTips: ControlTips = null
var item_names: Array = ["Canned Food", "Cereal", "Catnip", "Milk", "Drinks", "Ice Cream"]

var shop_item_names: Array = ["Shelf", "Freezer", "Counter", "Loading Zone"]
var shop_item_description: Array = ["Store regular items to sell", "Store frozen items to sell",
"Cashiers will collect customer payments here", "Supplies will drop here when you buy them"]

var hire_desc: Array = ["Stays at a checkout and collects payments", "Restocks your storage units with available boxes"]

var player_appearance_data: Array = [0, 0]

func _registerStorageUnitTooltip(tooltip: StorageTooltip):
	storageUnitTooltip = tooltip

func _registerControlTooltips(tooltip: ControlTips):
	controlTips = tooltip
