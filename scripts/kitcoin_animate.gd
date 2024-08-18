extends Node2D

class_name KitcoinAnimate

@export var checked_out = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
		if not Engine.is_editor_hint():
			if checked_out:
				animation_player.play("new_animation")
	
