extends Node

class_name TipsHelper

var storageUnitTooltip: StorageTooltip = null
var controlTips: ControlTips = null
var item_names: Array = ["Canned Food", "Cereal", "Catnip"]

func _registerStorageUnitTooltip(tooltip: StorageTooltip):
	storageUnitTooltip = tooltip

func _registerControlTooltips(tooltip: ControlTips):
	controlTips = tooltip
