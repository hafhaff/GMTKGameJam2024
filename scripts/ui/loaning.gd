extends Node

@onready var loanTimer: Timer = $Timer
@onready var transitionTimer: Timer = $Timer2
@onready var progressBar: ProgressBar = $InstallmentProgress/ProgressBar
@onready var label: Label = $LoanGuy/Message
@onready var label2: Label = $InstallmentProgress/Label
@onready var tooltip: Control = $LoanGuy
@onready var kitty_display: KittyDisplay = $LoanGuy/Panel/SubViewportContainer/SubViewport/KittyDisplay

var tooltipShown: bool = true
var installment: int = 50
var installmentIncrement: int = 80
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

func _ready():
	loanTimer.connect("timeout", _payInstalment)
	transitionTimer.connect("timeout", _toggleTooltip)
	transitionTimer.start(10)
	kitty_display.randomize_look()
	kitty_display.set_role(3)

func _process(_delta):
	progressBar.value = loanTimer.time_left / 90.0

func _payInstalment():
	global_shop._removeKitcoin(installment)
	installment += installmentIncrement
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
