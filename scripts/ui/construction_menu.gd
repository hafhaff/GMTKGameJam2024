extends Node

@onready var largeKitten: KittyDisplay = $KittyDisplay
@onready var largeKittenPos: Vector2 = $KittyDisplay.global_position
@onready var smolKittenHolder: Node = $"Construction Kitties"

var visible = true
var largeKittenHidePos: Vector2

func _ready():
	largeKittenHidePos = largeKittenPos + Vector2(largeKittenPos.x - 200.0, largeKittenPos.y)

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
