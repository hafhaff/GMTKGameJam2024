extends Panel

@export var tip: String = "Put your tip text here!"

@onready var tip_text: Label = $VBoxContainer/PanelContainer/TipText
@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	tip_text.text = tip

func _on_mouse_entered() -> void:
	v_box_container.visible = true

func _on_mouse_exited() -> void:
	v_box_container.visible = false
