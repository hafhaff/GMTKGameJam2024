extends Button

@onready var tooltip: Panel = $Tooltip

func _on_mouse_entered() -> void:
	tooltip.visible = true

func _on_mouse_exited() -> void:
	tooltip.visible = false
