extends Node

class_name CurrencyDisplay

@onready var displayLabel: Label = $MarginContainer/HBoxContainer/Label

func _ready():
	global_shop.connect("kitcoinUpdated", _updateDisplay)
	_updateDisplay(global_shop.kitcoins)

func _updateDisplay(value: float):
	displayLabel.text = str(value) + " Kitcoins"
	
func autoUpdateDisplay():
	displayLabel.text = str(global_shop.kitcoins) + " Kitcoins"
