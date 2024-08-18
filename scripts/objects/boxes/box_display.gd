@tool
extends Node2D

class_name BoxDisplay

@export var itemType: ItemGlobal.FoodTypes

@onready var base: Sprite2D = $Base
@onready var opening: AnimatedSprite2D = $Opening

# Customization
func update_box_type(index: int) -> void:
	base.region_rect.position.x = index * 32 
