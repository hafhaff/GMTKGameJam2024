@tool
extends Node2D

class_name KittyDisplay

enum KittyColor {SCRATCH, BLACK, WHITE, TUXEDO, CALICO, BROWNIE, BLUE, SILVER, POINT, GRAY}
enum KittyFace {NEUTRAL, ANGRY, ANNOYED, EXCITED, ROCK}

@export var kitty_color: KittyColor
@export var kitty_face: KittyFace

@onready var base: Sprite2D = $Sprites/Base
@onready var face: Sprite2D = $Sprites/Face

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		set_color(kitty_color)
		set_face(kitty_face)

func set_color(index: int) -> void:
	base.region_rect.position.x = (index * 32)
	
func set_face(index: int) -> void:
	face.region_rect.position.x = (index * 32)
