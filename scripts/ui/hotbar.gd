extends Node

@export var hiringMenu: Node
@export var purchasingMenu: Node
@export var constructionMenu: Node

@onready var buildButton: Button = $Build
@onready var suppliesButton: Button = $Supplies
@onready var hireButton: Button = $Hire

func _ready():
	buildButton.connect("pressed", constructionMenu._toggleDisplay)
	suppliesButton.connect("pressed", purchasingMenu._hide)
	hireButton.connect("pressed", hiringMenu._toggleDisplay)