extends Node

@onready var loanTimer: Timer = $Timer
@onready var transitionTimer: Timer = $Timer2
@onready var progressBar: ProgressBar = $InstallmentProgress/ProgressBar
@onready var label: Label = $LoanGuy/Message
@onready var label2: Label = $InstallmentProgress/Label
@onready var tooltip: Control = $LoanGuy
@onready var kitty_display: KittyDisplay = $LoanGuy/Panel/SubViewportContainer/SubViewport/KittyDisplay
@onready var _name: Label = $LoanGuy/Panel/catName

var tooltipShown: bool = true
var installment: int = 50
var installmentIncrement: int = 80
var shozSizeAddition: int = 10
var showPos: Vector2 = Vector2(397, 40)
var hidePos: Vector2 = Vector2(397, -98)
var supportiveTexts: Array[String] = [
	"Nice! You paid me!",
	"Great job! I got the money!",
	"Looking good man! I got the stuff",
	"Gonna buy so much catnip with this!",
	"Good stuff! Keep it up!",
	"You're doing great! I love money!",
	"This is where the fun begins!",
	"I love the sound of Kitcoins!",
	"Me? Greedy? Nah man!",
	"...should've open my own shop!"
]

var firstNames: Array[String] = [
	"Alfred", "Meowrio", "Purrcy", "Cornelius", "Madeline", "Puss",
	"Cake", "Jake", "Katoo", "Kate", "Tigris", "Danny", "Zuni", "Bo", "Kormi",
	"Hya", "Nani", "Leo", "Pebbles", "Sylvester"
]

var lastNames: Array[String] = [
	"Montgomery", "Cheeto", "Katterson", "Mewington", "Litterbox", "Scratch", "Cumberbatch",
	"Meowsalot", "Softpaws", "Katterson", "Klinklank", "Wolfeschlegelsteinhausenbergerdorff",
	"Wolfgang", "Claws"
]

@export var looseScreen: LooseScreen

func _ready():
	loanTimer.connect("timeout", _payInstalment)
	transitionTimer.connect("timeout", _toggleTooltip)
	transitionTimer.start(10)
	kitty_display.randomize_look()
	kitty_display.set_role(3)
	_set_random_name()
	label2.text = "Next instalment: " + str(installment)

func _process(_delta):
	progressBar.value = loanTimer.time_left / 90.0

func _set_random_name():
	_name.text = firstNames.pick_random() + " " + lastNames.pick_random()

func _payInstalment():
	global_shop._removeKitcoin(installment)
	if global_shop.kitcoins < 0:
		if looseScreen == null:
			printerr("NO LOOSE SCREEN ASSIGNED")
			return
		looseScreen.visible = true
		looseScreen.pause()
		return
	installment += installmentIncrement + (shozSizeAddition * global_shop.chunkNum)
	label2.text = "Next instalment: " + str(installment)
	_toggleTooltip()
	transitionTimer.start(5)

func _toggleTooltip():
	if !tooltipShown:
		label.text = supportiveTexts.pick_random() + "\nBut I need more Kitcoin next time..."
		transitionTimer.start(5)
		tooltipShown = !tooltipShown
	else:
		tooltipShown = !tooltipShown
	print("Tooltip shown", tooltipShown)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(tooltip, "position", showPos if tooltipShown else hidePos, 0.5)
