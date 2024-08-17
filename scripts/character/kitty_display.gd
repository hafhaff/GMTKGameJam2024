@tool
extends Node2D

class_name KittyDisplay

enum KittyColor {SCRATCH, BLACK, WHITE, TUXEDO, CALICO, BROWNIE, BLUE, SILVER, POINT, GRAY}
enum KittyFace {NEUTRAL, ANGRY, ANNOYED, EXCITED, ROCK}
enum KittyRole {CUSTOMER, CASHIER, RESTOCKER, PLAYER}

@export var kitty_color: KittyColor
@export var kitty_face: KittyFace
@export var kitty_role: KittyRole

## Change between walking animation and idle animaion...duh
@export var is_walking = false

## Flips sprite
@export var is_flipped = false

@onready var base: Sprite2D = $Sprites/Base
@onready var face: Sprite2D = $Sprites/Face
@onready var outfit: Sprite2D = $Sprites/Outfit
@onready var all_sprites: Node2D = $Sprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_color(kitty_color)
	set_face(kitty_face)
	set_role(kitty_role)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		set_color(kitty_color)
		set_face(kitty_face)
		set_role(kitty_role)
	
	if not Engine.is_editor_hint():
		if is_walking:
			animation_player.play("kitty_walk")
		else:
			all_sprites.rotation = 0
			animation_player.play("kitty_idle")
		set_flipped(is_flipped)

## I think this one explains itself
func set_color(index: int) -> void:
	base.region_rect.position.x = (index * 32)

## This one too
func set_face(index: int) -> void:
	face.region_rect.position.x = (index * 32)

## And finally this one, not fully functioning yet
func set_role(index:int) -> void:
	outfit.region_rect.position.x = (index * 32)

## This is what you asked for sir Hullahpop
func randomize_look() -> void:
	set_color(randi_range(0, KittyColor.size() - 1))
	if randi_range(0, 4) == 1:
		set_face(randi_range(1, KittyFace.size() - 1))
	else:
		set_face(0)
	set_role(kitty_role)

func set_flipped(arg: bool) -> void:
	base.flip_h = arg
	face.flip_h = arg
	outfit.flip_h = arg
