extends Node

@onready var largeKitten: KittyDisplay = $KittyDisplay
@onready var smolKittenHolder: Node = $"Construction Kitties"

@export var selections: Array[PackedScene]
@export var selectionDisplay: SelectionDisplay

var visible = true
var largeKittenHidePos: Vector2 = Vector2(-130, 784)	#Yup, shit's hardcoded
var largeKittenPos: Vector2 = Vector2(96,784)
var constPos: Vector2
var selection: PackedScene

func _ready():
	_toggleDisplay()
	selection = selections[0]

func _process(_delta):
	constPos = floor(get_tree().root.get_child(1).get_global_mouse_position()/32)
	selectionDisplay.global_position = constPos * 32
	if global_shop.shopShelves.has(Vector2i(constPos.x, constPos.y- 1)) || global_shop.shopShelves.has(Vector2i(constPos.x, constPos.y + 1)):
		selectionDisplay.selectionSprite.modulate = Color.RED
	else:
		selectionDisplay.selectionSprite.modulate = Color.GREEN

func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action_pressed('construction'):
			_toggleDisplay()
		if event.is_action_pressed('construct'):
			_build()

func _toggleDisplay():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(largeKitten, "global_position", largeKittenHidePos if visible else largeKittenPos, 0.5)

	for child in smolKittenHolder.get_children():
		child._hideKitty(visible)
	visible = !visible
	set_process(visible)
	selectionDisplay.visible = visible

func _build():
	if selectionDisplay.selectionSprite.modulate != Color.GREEN:
		return
	var building = selection.instantiate()
	building.global_position = constPos * 32
	get_tree().root.get_child(1).add_child(building)
	_spriteSetup(constPos as Vector2i, constPos as Vector2i)

func _spriteSetup(pos: Vector2i, parentPos: Vector2i):
	var left: Vector2i = Vector2i(pos.x -1, pos.y)
	var right: Vector2i = Vector2i(pos.x +1, pos.y)
	if global_shop.shopShelves.has(left) :
		if (left != parentPos): _spriteSetup(left, pos)
		if global_shop.shopShelves.has(right):
			if (right != parentPos): _spriteSetup(right, pos)
			global_shop.shopShelves[pos].sprite.texture.region_rect.position.x = 64
			return
		global_shop.shopShelves[pos].sprite.region_rect.position.x = 32
		return
	elif global_shop.shopShelves.has(Vector2i(pos.x +1, pos.y)):
		if (right != parentPos): _spriteSetup(right, pos)
		global_shop.shopShelves[pos].sprite.texture.region_rect.position.x = 96
		return