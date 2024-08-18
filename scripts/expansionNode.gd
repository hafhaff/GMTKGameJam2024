extends Node2D

enum DIRECTION {UP, DOWN, LEFT, RIGHT}

@export var direction = DIRECTION.UP


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var rightExpansionCorner = Vector2i(10,0)
var leftExpansionCorner = Vector2i(-10,0)

var chunksExpand = 1
var numExpansions = 1
var price = 10
var startX
var startY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getCenterGloabal(point1, point2):
	return 320*((point1 + point2)/2)
	
func updateNodePosition():
	if direction == DIRECTION.UP:
		position.x = getCenterGloabal(global_shop.topLeft.x, global_shop.topRight.x )
		position.y = global_shop.topLeft.y *320
	if direction == DIRECTION.DOWN:
		position.x = getCenterGloabal(global_shop.topLeft.x, global_shop.topRight.x )
		position.y = global_shop.bottomLeft.y *320
	if direction == DIRECTION.LEFT:
		position.y = getCenterGloabal(global_shop.topLeft.y, global_shop.bottomLeft.y )
		position.x = global_shop.bottomLeft.x *320
	if direction == DIRECTION.RIGHT:
		position.y = getCenterGloabal(global_shop.topRight.y, global_shop.bottomRight.y )
		position.x = global_shop.bottomRight.x *320

func moveExpansionMarker(amount = 320):
	translate( Vector2(amount,0) )
	
func getNumChunksBetweenNodes(point1, point2):
	return (abs(point1) + abs(point2))/9

func expand():
	
	if direction == DIRECTION.UP:
		chunksExpand = getNumChunksBetweenNodes(global_shop.topLeft, global_shop.topRight)
		startX = global_shop.topLeft.x
		startY = global_shop.topLeft.y - 10
		global_shop.topRight.y =+ 10
		global_shop.topLeft.y =+ 10
	
	updateNodePosition()
	print("new chunk")
	
	for n in chunksExpand + 1:
		$"../TileMapLayer".newChunk((startX + 9*n), startY)
		

func _input(event):
	pass
	

func rightExpansion(body):
	if body is Player and global_shop.getKitcoin() > price:
		global_shop._removeKitcoin(price)
		price = price * numExpansions
		expand()
		numExpansions = numExpansions + 1
		global_shop.addChunkNum(1)
	else:
		pass # Replace with function body.
