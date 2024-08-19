extends Node2D

class_name DeliveryPoint

@export var maxBoxes: int = 5
@export var boxTemplate: PackedScene
@export var enableBoxGeneration: bool

var relatedBoxes: Array[Box] = []

@onready var generationTimer: Timer = $Timer

func _ready():
	global_position = floor(global_position/32)*32	#Important for the tilemap, BUT we'll handle placement differently later
	global_shop._registerDeliveryPoint(self)
	if enableBoxGeneration:
		generationTimer.connect("timeout", _generateNewBox)
	else:
		generationTimer.queue_free()

func _generateNewBox():
	if relatedBoxes.size() >= maxBoxes:
		return

	var box: Box = boxTemplate.instantiate()
	box.itemType = randi_range(0, ItemGlobal.FoodTypes.size() - 1) as ItemGlobal.FoodTypes
	add_child(box)
	box.update_box_type()
	box.connect("selfYeet", _removeBox)
	relatedBoxes.push_back(box)
	box.global_position = global_position + Vector2(randf_range(0, 96), randf_range(0, 96))

func _removeBox(box: Box):
	relatedBoxes.erase(box)