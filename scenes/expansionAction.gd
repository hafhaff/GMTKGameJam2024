extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var topLeft = Vector2i(10,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func moveExpansionMarker(amount = 320):
	translate( Vector2(amount,0) )

func _on_body_entered(body): 
	moveExpansionMarker()
	print("new chunk")
	$"../TileMapLayer".newChunk(topLeft)
	topLeft.x = topLeft.x + 10
	pass # Replace with function body.
