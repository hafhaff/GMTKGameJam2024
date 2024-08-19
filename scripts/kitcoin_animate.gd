extends Node2D

class_name KitcoinAnimate

@export var checked_out = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if checked_out:
			animation_player.play("new_animation")

func _on_animation_finished(anim_name: String):
	if anim_name == "new_animation":
		checked_out = false
