extends Node

class_name TipsHelper

var storageUnitTooltip: StorageTooltip = null
var controlTips: ControlTips = null

func _registerStorageUnitTooltip(tooltip: StorageTooltip):
	storageUnitTooltip = tooltip

func _registerControlTooltips(tooltip: ControlTips):
	controlTips = tooltip
