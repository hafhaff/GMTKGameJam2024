extends Panel

class_name StorageTooltip

@onready var name_label: Label = $Name
@onready var capacity: Label = $Capacity

var item_names: Array = ["Canned Food", "Cereal", "Catnip"] 
var format_string = "%s/%s"

func _ready() -> void:
	GlobalTipsHelper._registerStorageUnitTooltip(self)

func set_tooltip_display(type: int, current: int, max: int):
	name_label.text = get_item_name(type, current)
	capacity.text = format_string % [current, max]

func get_item_name(index: int, current:int) -> String:
	var name: String = "Unknown"
	
	if current < 1:
		name = "Empty"
	elif not index > item_names.size():
		name = item_names[index]
	
	return name
