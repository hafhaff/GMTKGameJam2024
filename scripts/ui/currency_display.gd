extends Node

class_name CurrencyDisplay

@onready var displayLabel: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var labelContainer: VBoxContainer = $MarginContainer/VBoxContainer/kitcoinDifference

func _ready():
	global_shop.connect("kitcoinUpdated", _updateDisplay)
	global_shop.connect("kitcoinDifference", self.showKitcoinDifference)
	_updateDisplay(global_shop.kitcoins)

func _updateDisplay(value: float):
	displayLabel.text = str(value) + " Kitcoins"
	
func autoUpdateDisplay():
	displayLabel.text = str(global_shop.kitcoins) + " Kitcoins"


func showKitcoinDifference(diff: float):
	# Create a new label for the difference
	var diffLabel = Label.new()
	if diff == 0:
		return
	if diff > 0:
		diffLabel.text = "+" + str(diff) + " Kitcoins"
		diffLabel.add_theme_color_override("font_color", Color(0, 1, 0))  # Green for gain
	else:
		diffLabel.text = str(diff) + " Kitcoins"
		diffLabel.add_theme_color_override("font_color", Color(1, 0, 0))  # Red for loss
	
	diffLabel.add_theme_font_size_override("font_size", 22)
	
	labelContainer.add_child(diffLabel)
	labelContainer.move_child(diffLabel, 0)
	
	# Set initial position for animation
	diffLabel.position = Vector2(0, 0)
	
	# Move existing labels down
	moveExistingLabelsDown()
	
	# Animate the label to move down and fade out
	animateLabel(diffLabel)


# Move existing labels down
func moveExistingLabelsDown():
	for i in range(labelContainer.get_child_count() - 1):
		var label = labelContainer.get_child(i)
		if label is Label:
			label.position.y += 30  # Adjust this value based on label height


# Animate the label to move down and fade out
func animateLabel(label: Label):
	var tween = create_tween()

	# Move the label down over 0.5 seconds
	#tween.tween_property(label, "position:y", label.position.y + 50, 0.5)
	# Fade the label out over 5 seconds
	tween.tween_property(label, "modulate:a", 0, 5)

	# Queue the label for deletion after the animation completes
	tween.connect("finished", Callable(label, "queue_free"))
	
