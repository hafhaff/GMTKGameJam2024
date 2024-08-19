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
var currentChunk
var numChunks
var price = 10
var startX
var startY

var canBuild = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getCenterGloabal(point1, point2):
	return 320*((point1 + point2)/2)
	
func updateNodePosition():
	if direction == DIRECTION.UP:
		moveExpansionMarker(0, -320)
	if direction == DIRECTION.DOWN:
		moveExpansionMarker(0, 320)
	if direction == DIRECTION.LEFT:
		moveExpansionMarker(-320, 0)
	if direction == DIRECTION.RIGHT:
		moveExpansionMarker(320,0)

func moveExpansionMarker(amountX = 320, amountY=0):
	translate( Vector2(amountX,amountY))
	
func getNumChunksBetweenNodes(point1, point2):
	return (abs(point1) + abs(point2))/9

func expand():
	
	if direction == DIRECTION.UP:
		chunksExpand = getNumChunksBetweenNodes(global_shop.topLeft.x, global_shop.topRight.x)
		
		startX = global_shop.topLeft.x
		startY = global_shop.topLeft.y - 10
		global_shop.topRight.y = global_shop.topRight.y - 10
		global_shop.topLeft.y = global_shop.topLeft.y - 10
		updateNodePosition()
		print("new chunk up")
		
		global_shop.chunkNum = chunksExpand + global_shop.chunkNum 
		
		for i in chunksExpand:
			
			$"../TileMapLayer".newChunk(startX, startY)
			startX = startX + 10
			
		$"../TileMapLayer".fillHorizontalWall(global_shop.topLeft, global_shop.topRight, 1)
			
	if direction == DIRECTION.DOWN:
		chunksExpand = getNumChunksBetweenNodes(global_shop.bottomLeft.x, global_shop.bottomRight.x)
		
		print(" chunk width")
		print(chunksExpand)
		print("----")
		
		print(global_shop.bottomLeft)
		print(global_shop.bottomRight)
		
		startX = global_shop.bottomLeft.x
		startY = global_shop.bottomLeft.y + 1
		global_shop.bottomRight.y = global_shop.bottomRight.y+ 10
		global_shop.bottomLeft.y = global_shop.bottomLeft.y + 10
		updateNodePosition()
		print("new chunk up")
		#chunksExpand = chunksExpand + 1 
		
		global_shop.chunkNum = chunksExpand + global_shop.chunkNum 
		
		for i in chunksExpand:
			
			
			
			print("chunk " + str(i) + " made at")
			print(startX)
			print(startY)
			print("----------------")
			
			$"../TileMapLayer".newChunk(startX, startY)
			startX = startX + 10
		print(global_shop.bottomLeft)
		print(global_shop.bottomRight)
		$"../TileMapLayer".fillHorizontalWall(global_shop.bottomLeft, global_shop.bottomRight, 0)
	
	
	if direction == DIRECTION.RIGHT:
		chunksExpand = getNumChunksBetweenNodes(global_shop.topRight.y, global_shop.bottomRight.y)
		print(global_shop.topRight.x)
		startX = global_shop.topRight.x + 1
		startY = global_shop.topRight.y
		global_shop.topRight.x = global_shop.topRight.x + 10
		global_shop.bottomRight.x = global_shop.bottomRight.x + 10
		updateNodePosition()
		print("new chunk up")
		#chunksExpand =+ 1
		
		global_shop.chunkNum = chunksExpand + global_shop.chunkNum 
		
		for i in chunksExpand:
			
			
			
			print("chunk " + str(i) + " made at")
			print(startX)
			print(startY)
			print("----------------")
			
			$"../TileMapLayer".newChunk(startX, startY)
			startY = startY + 10
		print(global_shop.bottomLeft)
		print(global_shop.bottomRight)
		
		$"../TileMapLayer".fillSideWall(global_shop.topRight, global_shop.bottomRight, 0)
		
		
	if direction == DIRECTION.LEFT:
		chunksExpand = getNumChunksBetweenNodes(global_shop.topLeft.y, global_shop.bottomLeft.y)
		
		print(" chunk width")
		print(chunksExpand)
		print("----")
		
		startX = global_shop.topLeft.x - 10
		startY = global_shop.topLeft.y
		global_shop.topLeft.x = global_shop.topLeft.x - 10
		global_shop.bottomLeft.x = global_shop.bottomLeft.x - 10
		updateNodePosition()
		print("new chunk up")
		#chunksExpand =+ 1
		
		global_shop.chunkNum = chunksExpand + global_shop.chunkNum 
		
		for i in chunksExpand:
			
			$"../TileMapLayer".newChunk(startX, startY)
			startY = startY + 10
		$"../TileMapLayer".fillSideWall(global_shop.topLeft, global_shop.bottomLeft, 1)
		
	fixWalls()

func _input(event):
	pass
	
func fixWalls():
	$"../TileMapLayer".fillHorizontalWall(global_shop.bottomLeft, global_shop.bottomRight, 0)
	$"../TileMapLayer".fillHorizontalWall(global_shop.topLeft, global_shop.topRight, 1)
	$"../TileMapLayer".fillHorizontalWall(global_shop.bottomLeft, global_shop.bottomRight, 0)
	$"../TileMapLayer".fillSideWall(global_shop.topRight, global_shop.bottomRight, 0)
	$"../TileMapLayer".fillSideWall(global_shop.topLeft, global_shop.bottomLeft, 1)

func rightExpansion(body):
	if body is Player and global_shop.getKitcoin() > price:
		global_shop._removeKitcoin(price)
		price = price * numExpansions
		expand()
		numExpansions = numExpansions + 1
		global_shop.addChunkNum(1)
	else:
		pass # Replace with function body.
		



func _on_canvas_layer_2_visibility_changed():
	print("toggle")
	pass # Replace with function body.
