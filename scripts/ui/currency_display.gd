extends Node

class_name CurrencyDisplay

@onready var displayLabel: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var labelContainer: VBoxContainer = $kitcoinDifference
@onready var wages: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Label


var wages_per_min = 0

func _ready():
	global_shop.connect("kitcoinUpdated", _updateDisplay)
	global_shop.connect("kitcoinDifference", self.showKitcoinDifference)
	_updateDisplay(global_shop.kitcoins)
	update_wages()

func _updateDisplay(value: float):
	displayLabel.text = str(value) + " Kitcoins"
	
func autoUpdateDisplay():
	displayLabel.text = str(global_shop.kitcoins) + " Kitcoins"


func showKitcoinDifference(diff: float):
	var diffLabel = Label.new()
	if diff == 0:
		return
	if diff > 0:
		diffLabel.text = "+" + str(diff) + " Kitcoins"
		diffLabel.add_theme_color_override("font_color", Color(0, 1, 0))  # Green for gain
	else:
		diffLabel.text = str(diff) + " Kitcoins"
		diffLabel.add_theme_color_override("font_color", Color(1, 0, 0))  # Red for loss
	
	diffLabel.add_theme_font_size_override("font_size", 11)
	
	diffLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	labelContainer.add_child(diffLabel)
	labelContainer.move_child(diffLabel, 0)
	
	# Set initial position for animation
	diffLabel.position = Vector2(0, 0)
	
	moveExistingLabelsDown()
	animateLabel(diffLabel)


func moveExistingLabelsDown():
	for i in range(labelContainer.get_child_count() - 1):
		var label = labelContainer.get_child(i)
		if label is Label:
			label.position.y += 30  # Adjust this value based on label height


func animateLabel(label: Label):
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0, 5)
	tween.connect("finished", Callable(label, "queue_free"))


func set_wages(new_wage: int):
	wages_per_min = new_wage
	update_wages()

func update_wages():
	wages.text = "Wages: %s/h" % wages_per_min
