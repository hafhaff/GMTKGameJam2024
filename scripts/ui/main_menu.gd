extends Control

@export var selectSoundPlayer: AudioStreamPlayer
@export var switchSoundPlayer: AudioStreamPlayer
@export var musicPlayer: AudioStreamPlayer
@export var musicTimeout: Timer
@export var animationHolder: Control
@export var menus: Array[CanvasItem]
@export var pb1: ParallaxBackground = null
@export var loadingScreen: Panel

var activeMenu: CanvasItem

@onready var scenes = [
	"res://scenes/tests/splitScreenTest.tscn"
]
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	await get_tree().create_timer(0.5).timeout
	for child in animationHolder.get_children():
			for node in child.get_children():
				if node is Button:
					node.connect("mouse_entered", _playSwitch)
					node.connect("pressed", _playSelect)
	musicTimeout.connect("timeout", _playMusic)
	musicPlayer.connect("finished", _timeoutMusic)
	musicPlayer.play(1)
	activeMenu = menus[0]	#0 is always the main menu
	animationPlayer.play("main_menu_ambience")
	get_tree().paused = false

func _process(_delta):
	pb1.scroll_offset = get_global_mouse_position() - (Vector2(DisplayServer.window_get_size()/7))	#why 7, only the gods know

func _playSwitch():
	if switchSoundPlayer.playing:
		switchSoundPlayer.stop()
	switchSoundPlayer.play()

func _playSelect():
	if selectSoundPlayer.playing:
		selectSoundPlayer.stop()
	selectSoundPlayer.play()

func _playMusic():
	musicPlayer.play()

func _timeoutMusic():
	musicTimeout.start(2.5)

func _exitGame():
	get_tree().quit()

func _switchMenu(selection: int = 0):
	print("menu switch")
	activeMenu.visible = false
	menus[selection].visible = true
	activeMenu = menus[selection]
	if activeMenu is Panel:
		animationPlayer.stop()
	else:
		if !animationPlayer.is_playing():
			animationPlayer.play("main_menu_ambience")

func _switchScenes(value: int = 0):
	activeMenu.visible = false
	loadingScreen.visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().change_scene_to_file(scenes[value])