extends Node

@onready var largeKitten: KittyDisplay = $KittyDisplay
@onready var smolKittenHolder: Node = $"Construction Kitties"
@onready var selectionPositioning: Node2D = $SelectionPositioning
@onready var selectionSprite: Sprite2D = $SelectionPositioning/Sprite2D

@export var selections: Array[PackedScene]
@export var selectionDisplay: SelectionDisplay
@export var hiringMenu: Node
@export var tilemap: TileMapLayer

var visible = true
var largeKittenHidePos: Vector2 = Vector2(-130, 784)	#Yup, shit's hardcoded
var largeKittenPos: Vector2 = Vector2(96,784)
var selectionPos: Vector2 = Vector2(620,593)
var selectionHiddenPos: Vector2 = Vector2(620,893)
var constPos: Vector2
var selection: PackedScene
var selectionNum = 0

signal visibilityToggled(bool)

func _ready():
	_toggleDisplay()
	selection = selections[0]
	if tilemap == null:
		printerr("ERROR: CONSTRUCTION SCENE DOES NOT HAVE A TILEMAP SET. SELF YEETING IMMINENT!")
		queue_free()

func _process(_delta):
	constPos = floor(get_tree().root.get_child(1).get_global_mouse_position()/32)
	selectionDisplay.global_position = constPos * 32

	if selectionNum == 2:
		for x in range(3):
			for y in range(3):
				var constPosCheck = constPos
				constPosCheck = constPosCheck + Vector2(x, y)
				if (
					global_shop.shopShelves.has(Vector2i(constPosCheck.x, constPosCheck.y- 1)) || 
					global_shop.shopShelves.has(Vector2i(constPosCheck.x, constPosCheck.y + 1)) || 
					global_shop.shopShelves.has(constPosCheck as Vector2i) ||
					global_shop.shopDeliveryPoints.has(constPosCheck as Vector2i) ||
					global_shop.shopCounters.has(constPosCheck as Vector2i) ||
					tilemap.get_cell_tile_data(constPosCheck) == null ||
					tilemap.get_cell_tile_data(constPosCheck).get_navigation_polygon(0) == null
				):
					selectionDisplay.selectionSprite.modulate = Color.RED
					#printt(constPos, Vector2(x, y), constPosCheck)
					return
				else:
					selectionDisplay.selectionSprite.modulate = Color.GREEN
	else:
		if (
			global_shop.shopShelves.has(Vector2i(constPos.x, constPos.y- 1)) || 
			global_shop.shopShelves.has(Vector2i(constPos.x, constPos.y + 1)) || 
			global_shop.shopShelves.has(constPos as Vector2i) ||
			global_shop.shopDeliveryPoints.has(constPos as Vector2i) ||
			global_shop.shopCounters.has(constPos as Vector2i) ||
			tilemap.get_cell_tile_data(constPos) == null ||
			tilemap.get_cell_tile_data(constPos).get_navigation_polygon(0) == null
		):
			selectionDisplay.selectionSprite.modulate = Color.RED
		else:
			selectionDisplay.selectionSprite.modulate = Color.GREEN


func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action_pressed('construction'):
			if hiringMenu != null && !hiringMenu.visible:
				_toggleDisplay()
		if event.is_action_pressed('construct'):
			_build()
		if event.is_action_pressed('construction_next'):
			_selectionChange(true)
		if event.is_action_pressed('construction_prev'):
			_selectionChange(false)

func _toggleDisplay():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(largeKitten, "global_position", largeKittenHidePos if visible else largeKittenPos, 0.5)

	var tweenTheSecond = create_tween()
	tweenTheSecond.set_trans(Tween.TRANS_QUAD)
	tweenTheSecond.set_ease(Tween.EASE_OUT)
	tweenTheSecond.tween_property(selectionPositioning, "global_position", selectionHiddenPos if visible else selectionPos, 0.5)

	for child in smolKittenHolder.get_children():
		child._hideKitty(visible)
	visible = !visible
	set_process(visible)
	selectionDisplay.visible = visible
	visibilityToggled.emit(visible)

func _build():
	if selectionDisplay.selectionSprite.modulate != Color.GREEN || !visible:
		print("Construction Cancelled!")
		return
	var building = selection.instantiate()
	
	building.global_position = constPos * 32
	
	global_shop.buy(global_shop.prices[getItemName(building)])
	
	get_tree().root.get_child(1).add_child(building)
	_spriteSetup(constPos as Vector2i, constPos as Vector2i)

func _spriteSetup(pos: Vector2i, parentPos: Vector2i):
	if !global_shop.shopShelves.has(pos):
		return
	var left: Vector2i = Vector2i(pos.x -1, pos.y)
	var right: Vector2i = Vector2i(pos.x +1, pos.y)
	if global_shop.shopShelves.has(left):
		if (left != parentPos): _spriteSetup(left, pos)
		if global_shop.shopShelves.has(right):
			if (right != parentPos): _spriteSetup(right, pos)
			global_shop.shopShelves[pos].sprite.region_rect.position.x = 64
			return
		global_shop.shopShelves[pos].sprite.region_rect.position.x = 96
		return
	elif global_shop.shopShelves.has(Vector2i(pos.x +1, pos.y)):
		if (right != parentPos): _spriteSetup(right, pos)
		global_shop.shopShelves[pos].sprite.region_rect.position.x = 32
		return

func _selectionChange(next: bool):
	if !visible:
		return
	if next:
		if selectionNum + 1 <= selections.size()-1:
			selectionNum += 1
			selection = selections[selectionNum]
	else:
		if selectionNum - 1 >= 0:
			selectionNum -= 1
			selection = selections[selectionNum]
	selectionDisplay.selectionSprite.texture = selectionDisplay.selectionSprites[selection]
	selectionSprite.texture = selectionDisplay.selectionSprite.texture
	if selectionNum == 2:
		selectionDisplay.selectionSprite.scale = Vector2i(3,3)
		selectionDisplay.selectionSprite.position = Vector2(48,48)
	else:
		selectionDisplay.selectionSprite.scale = Vector2i(1,1)
		selectionDisplay.selectionSprite.position = Vector2(16,16)
		
func getItemName(building):
	if building is Shelf:
		return "shelf"
	if building is Counter:
		return "counter"
	if building is Box:
		return "box"
	if building is DeliveryPoint:
		return "loadingZone"
	else:
		print("not a buyable object")
		return "box"

	pass # Replace with function body.
