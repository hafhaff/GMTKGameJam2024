extends Button

@export var tooltip: String = "Tooltip"
@onready var tooltip_preview: TooltipPreview = %Tooltip

func _mouse_entered():
	tooltip_preview.visible = true
	print(global_position)
	print(tooltip)

func _mouse_exited():
	tooltip_preview.visible = false
