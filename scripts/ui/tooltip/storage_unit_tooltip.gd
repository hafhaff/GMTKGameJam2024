extends Panel

class_name StorageUnitTooltip

@onready var label: Label = $Label
var item_names: Array = ["Canned Food", "Cereal", "Catnip"] 
var format_string = "%s \n %s/%s"

func set_tooltip_display(type: int, current: int, max: int):
	label.text = format_string % [get_item_name(type, current), current, max]

func get_item_name(index: int, current:int) -> String:
	var name: String = "Unknown"
	
	if current < 1:
		name = "Empty"
	elif not index > item_names.size():
		name = item_names[index]
	
	return name
