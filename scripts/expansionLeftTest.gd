extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var rightExpansionCorner = Vector2i(10,0)
var leftExpansionCorner = Vector2i(-10,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func moveExpansionMarker(amount = -320):
	translate( Vector2(amount,0) )

func rightExpansion(body):
	moveExpansionMarker(-320)
	
	pass # Replace with function body.


func _on_body_entered(body):
	if body is Player:
		moveExpansionMarker(-320)
		print("new chunk")
		$"../TileMapLayer".newChunk(leftExpansionCorner)
		leftExpansionCorner.x = leftExpansionCorner.x - 10
	else:
		pass
