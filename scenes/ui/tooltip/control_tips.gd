extends VBoxContainer

class_name ControlTips

@onready var drop: Panel = $Drop
@onready var stock: Panel = $Stock
@onready var take: Panel = $Take

func _ready() -> void:
	GlobalTipsHelper._registerControlTooltips(self)
