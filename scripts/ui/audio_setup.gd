extends Node

@export var masterSlider: HSlider
@export var musicSlider: HSlider
@export var effectSlider: HSlider

func _ready():
	masterSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	musicSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	effectSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

	masterSlider.connect("value_changed", _changeMaster)
	musicSlider.connect("value_changed", _changeMusic)
	effectSlider.connect("value_changed", _changeEffect)

func _changeMaster(value):
	print(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value if value > -30 else -80)

func _changeMusic(value):
	print(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value if value > -30 else -80)

func _changeEffect(value):
	print(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value if value > -30 else -80)
