extends Node

@onready var largeKitten: KittyDisplay = $KittyDisplay
@onready var smolKittenHolder: Node = $"Construction Kitties"
@onready var selectionPositioning: Node2D = $SelectionPositioning
@onready var kittyDisplay: KittyDisplay = $SelectionPositioning/KittyDisplay
@onready var nameLabel: RichTextLabel = $SelectionPositioning/RichTextLabel

@export var selections: Array[PackedScene]
@export var selectionDisplay: KittyDisplay
@export var constructionMenu: Node

var visible = true
var largeKittenHidePos: Vector2 = Vector2(-130, 784)	#Yup, shit's hardcoded
var largeKittenPos: Vector2 = Vector2(96,784)
var selectionPos: Vector2 = Vector2(620,593)
var selectionHiddenPos: Vector2 = Vector2(620,893)
var constPos: Vector2
var selection: PackedScene
var selectionNum = 1

func _ready():
	_toggleDisplay()
	selection = selections[0]
	kittyDisplay.randomize_look()
	kittyDisplay.set_role(selectionNum)
	nameLabel.text = "[center]" + str(KittyDisplay.KittyRole.keys()[selectionNum])
	selectionDisplay.get_node("Sprites").get_node("Outfit").visible = false
	selectionDisplay.get_node("Sprites").get_node("Face").visible = false
	selectionDisplay.get_node("Sprites").get_node("Base").modulate = Color.GREEN

func _process(_delta):
	selectionDisplay.global_position = get_tree().root.get_child(1).get_global_mouse_position() + Vector2(0,9)

func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action_pressed('hiring'):
			if constructionMenu != null && !constructionMenu.visible:
				_toggleDisplay()
		if event.is_action_pressed('hire'):
			_build()
		if event.is_action_pressed('hiring_next'):
			_selectionChange(true)
		if event.is_action_pressed('hiring_prev'):
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
	if visible:
		kittyDisplay.randomize_look()
		kittyDisplay.set_role(selectionNum)
	selectionDisplay.visible = visible

func _build():
	if !visible:
		print("Construction Cancelled!")
		return
	var building = selection.instantiate()
	building.global_position = get_tree().root.get_child(1).get_global_mouse_position()
	get_tree().root.get_child(1).add_child(building)

func _selectionChange(next: bool):
	if !visible:
		return
	if selectionNum == 1:
		selectionNum = 2
	else:
		selectionNum = 1
	selection = selections[selectionNum - 1]
	kittyDisplay.set_role(selectionNum)
	nameLabel.text = "[center]" + str(KittyDisplay.KittyRole.keys()[selectionNum])
