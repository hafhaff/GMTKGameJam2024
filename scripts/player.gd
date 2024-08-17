extends CharacterBody2D

@export var speed: float = 100

func _ready():
	position = Vector2(100, 100)


func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	
