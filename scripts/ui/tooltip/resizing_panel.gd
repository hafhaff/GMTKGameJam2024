extends Panel

class_name TooltipPreview

@onready var label: Label = $Label

func set_tooltip(tip: String, pos: Vector2):
	label.text = tip
