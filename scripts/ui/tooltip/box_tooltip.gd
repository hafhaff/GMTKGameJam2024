extends Panel

class_name BoxTooltip

@onready var name_label: Label = $Name
@onready var capacity: Label = $Capacity

var format_string = "%s/%s"

func set_tooltip_display(type: int, current: int, max: int):
	name_label.text = get_item_name(type, current)
	capacity.text = format_string % [current, max]

func get_item_name(index: int, current:int) -> String:
	var name: String = "Unknown"
	
	if current < 1:
		name = "Empty"
	elif not index > GlobalTipsHelper.item_names.size():
		name = GlobalTipsHelper.item_names[index]
	
	return name
