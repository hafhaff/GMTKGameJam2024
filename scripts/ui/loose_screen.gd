extends CanvasLayer

class_name LooseScreen

@onready var scenes = [
	"res://scenes/expansion_test.tscn",
	"res://scenes/main_menu_concept.tscn"
]

func pause():
	visible = !get_tree().paused
	get_tree().paused = !get_tree().paused

func _switchScenes(value: int = 0):
	global_shop._clearShop()
	get_tree().paused = false
	get_tree().change_scene_to_file(scenes[value])
