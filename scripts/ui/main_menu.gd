extends Control

@export var selectSoundPlayer: AudioStreamPlayer
@export var switchSoundPlayer: AudioStreamPlayer
@export var backSoundPlayer: AudioStreamPlayer
@export var musicPlayer: AudioStreamPlayer
@export var menus: Array[CanvasItem]
@export var loadingScreen: Panel
@export var creditsPanel: Panel

var activeMenu: CanvasItem

@onready var scenes = [
	"res://scenes/expansion_test.tscn"
]

func _ready():
	await get_tree().create_timer(0.5).timeout
	for child in get_children():
			for node in child.get_children():
				if node is Button:
					node.connect("mouse_entered", _playSwitch)
					if node.text == "Back":
						node.connect("pressed", _playBack)
					else:
						node.connect("pressed", _playSelect)
	musicPlayer.play(1)
	activeMenu = menus[0]	#0 is always the main menu
	get_tree().paused = false

func _playSwitch():
	if switchSoundPlayer.playing:
		switchSoundPlayer.stop()
	switchSoundPlayer.play()

func _playSelect():
	if selectSoundPlayer.playing:
		selectSoundPlayer.stop()
	selectSoundPlayer.play()

func _playBack():
	if backSoundPlayer.playing:
		backSoundPlayer.stop()
	backSoundPlayer.play()

func _playMusic():
	musicPlayer.play()

func _exitGame():
	get_tree().quit()

func _switchMenu(selection: int = 0):
	print("menu switch")
	activeMenu.visible = false
	menus[selection].visible = true
	activeMenu = menus[selection]

func _switchScenes(value: int = 0):
	activeMenu.visible = false
	loadingScreen.visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	global_shop._clearShop()
	get_tree().change_scene_to_file(scenes[value])

func _toggleCredits():
	_switchMenu(0 if creditsPanel.visible else 2)
	creditsPanel.visible = !creditsPanel.visible
