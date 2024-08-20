extends CanvasLayer

@export var mainMenuScene = "res://scenes/main_menu_concept.tscn"
@export var switchSoundPlayer: AudioStreamPlayer
@export var selectSoundPlayer: AudioStreamPlayer
@export var backSoundPlayer: AudioStreamPlayer
@export var optionsMenu: Panel

func _ready():
	for child in get_node("Panel").get_children():
			for node in child.get_children():
				if node is Button:
					node.connect("mouse_entered", _playSwitch)
					if node.text == "Back":
						node.connect("pressed", _playBack)
					else:
						node.connect("pressed", _playSelect)
	#This is where the fun begins, jimbo
	for child in get_node("Panel").get_node("Panel").get_node("Panel").get_children():
			for node in child.get_children():
				if node is Button:
					node.connect("mouse_entered", _playSwitch)
					if node.text == "Back":
						node.connect("pressed", _playBack)
					else:
						node.connect("pressed", _playSelect)

func _input(event):
	if event.is_action_pressed("ui_pause"):
		pause()

func pause():
	visible = !get_tree().paused
	get_tree().paused = !get_tree().paused

func _return_to_menu():
	get_tree().paused = !get_tree().paused
	global_shop._clearShop()
	get_tree().change_scene_to_file(mainMenuScene)

func _playSwitch():
	if switchSoundPlayer.playing:
		switchSoundPlayer.stop()
	switchSoundPlayer.play()

func _playBack():
	if backSoundPlayer.playing:
		backSoundPlayer.stop()
	backSoundPlayer.play()

func _playSelect():
	if selectSoundPlayer.playing:
		selectSoundPlayer.stop()
	selectSoundPlayer.play()

func changeMenu():
	optionsMenu.visible = !optionsMenu.visible