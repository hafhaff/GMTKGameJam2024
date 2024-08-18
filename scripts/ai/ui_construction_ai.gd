extends CharacterBody2D

class_name UiConstructionAI

var speed: float
var moveY: float
var forcedHidden: bool

@onready var kittyDisplay: KittyDisplay = $KittyDisplay
@onready var movementTimer: Timer = $Timer
@onready var spawnPosition: Vector2 = self.global_position
@onready var desiredPosition: Vector2 = self.global_position

func _ready():
	moveY = global_position.y
	kittyDisplay.randomize_look()
	kittyDisplay.set_role(KittyDisplay.KittyRole.CONSTRUCTION)
	set_physics_process(false)
	_generateDesiredPosition()

func _physics_process(_delta):
	if global_position.distance_squared_to(desiredPosition) < 10:
		kittyDisplay.is_walking = false
		movementTimer.start(randi_range(3, 6))
		set_physics_process(false)
		return
	velocity = global_position.direction_to(desiredPosition) * speed
	kittyDisplay.is_flipped = velocity.x < 0
	move_and_slide()

func _generateDesiredPosition():
	if is_physics_processing() || forcedHidden:
		movementTimer.start(randi_range(3, 6))
		return
	set_physics_process(true)
	kittyDisplay.is_walking = true
	speed = randf_range(50, 125)
	desiredPosition = Vector2(randf_range(spawnPosition.x, spawnPosition.x + 800), spawnPosition.y)

func _hideKitty(mustHide: bool):
	forcedHidden = mustHide
	var pushVector = Vector2(global_position.x, moveY + 50.0 if mustHide else moveY)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pushVector, 0.5)
	if mustHide:
		set_physics_process(false)
	else:
		tween.connect("finished", _tweenFinished)

func _tweenFinished():
	set_physics_process(kittyDisplay.is_walking)