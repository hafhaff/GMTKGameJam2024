extends Node

@onready var largeKitten: KittyDisplay = $KittyDisplay
@onready var smolKittenHolder: Node = $"Construction Kitties"

var visible = true
var largeKittenHidePos: Vector2 = Vector2(-130, 784)	#Yup, shit's hardcoded
var largeKittenPos: Vector2 = Vector2(96,784)

func _ready():
	_toggleDisplay()

func _process(_delta):
	pass

func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action_pressed('construction'):
			_toggleDisplay()

func _toggleDisplay():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(largeKitten, "global_position", largeKittenHidePos if visible else largeKittenPos, 0.5)

	for child in smolKittenHolder.get_children():
		print(child)
		child._hideKitty(visible)
	visible = !visible
