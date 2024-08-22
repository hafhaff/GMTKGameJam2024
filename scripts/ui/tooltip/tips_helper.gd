extends Node

class_name TipsHelper

var storageUnitTooltip: StorageTooltip = null
var controlTips: ControlTips = null
var item_names: Array = ["Canned Food", "Cereal", "Catnip", "Milk", "Drinks", "Ice Cream"]
var player_appearance_data: Array = [0, 0]

func _registerStorageUnitTooltip(tooltip: StorageTooltip):
	storageUnitTooltip = tooltip

func _registerControlTooltips(tooltip: ControlTips):
	controlTips = tooltip
