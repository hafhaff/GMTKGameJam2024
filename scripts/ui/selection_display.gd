extends Node2D

class_name SelectionDisplay

@export var selectionSprites: Dictionary

@onready var selectionSprite: Sprite2D = $Sprite2D

func _changeSprite(scene: PackedScene):
	if !selectionSprites.has(scene):
		printerr("Construction: Selection doesn't have a sprite associated!")

	selectionSprite.texture = selectionSprites[scene]