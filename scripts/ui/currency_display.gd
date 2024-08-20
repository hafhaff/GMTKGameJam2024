extends Node

class_name CurrencyDisplay

@onready var displayLabel: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var diffLabel: Label = $MarginContainer/VBoxContainer/kitcoinDifference

func _ready():
	global_shop.connect("kitcoinUpdated", _updateDisplay)
	global_shop.connect("kitcoinDifference", self.showKitcoinDifference)
	_updateDisplay(global_shop.kitcoins)

func _updateDisplay(value: float):
	displayLabel.text = str(value) + " Kitcoins"
	
func autoUpdateDisplay():
	displayLabel.text = str(global_shop.kitcoins) + " Kitcoins"


func showKitcoinDifference(diff: float):
	if diff > 0:
		diffLabel.text = "+ " + str(diff) + " Kitcoins"
		diffLabel.add_theme_color_override("font_color", Color(0, 1, 0))  # Green for gain
	else:
		diffLabel.text = str(diff) + " Kitcoins"
		diffLabel.add_theme_color_override("font_color", Color(1, 0, 0))  # Red for loss
	
	diffLabel.show()
	
	# Hide the label after 2 seconds
	await get_tree().create_timer(2).timeout
	diffLabel.hide()
