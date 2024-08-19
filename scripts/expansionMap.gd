extends NavmeshUpdater

class_name ExpansionMap

var rightWall = Vector2i(4,1)
var leftWall = Vector2i(2,1)
var  bottomWall = Vector2i(3,2)
var topWall = Vector2i(3,3)

#include Vector2i()
#TODO: Add walls in this
func newChunk(xNode, yNode):
	for x in 10:
		for y in 10:
			set_cell(Vector2i(xNode + x, yNode + y), 0 ,Vector2i(4,3))
			
#side = 0 is right
func fillSideWall(topPoint, bottomPoint, side = 1):
	
	var distance = abs (topPoint.y - bottomPoint.y) + 1
	
	var fillSide = leftWall
	var offset = -1
	
	if side == 0:
		fillSide = rightWall
		offset = 1
	
	for i in distance:
		set_cell(Vector2i(topPoint.x + offset , topPoint.y + i), 0, fillSide)
		print("wall at cell:")
		print (Vector2i(topPoint.y + i, topPoint.x + 1))
	
func fillHorizontalWall(leftPoint, rightPoint, side = 1):
	var distance = abs (leftPoint.x - rightPoint.x) + 1
	var fillSide = topWall
	var offset = -1
	
	if side == 0:
		fillSide = bottomWall
		offset = 1
		
	for i in distance:
		set_cell(Vector2i(leftPoint.x + i , rightPoint.y + offset), 0, fillSide)
		print(i)

	
	
	
	pass
	
func _ready():
	global_shop._registerTilemap(self)

func _removeNavmeshFromTile(vector: Vector2i):
	set_cell(vector, 0, Vector2i(4,3))

func _addNavmeshToTile(vector: Vector2i):
	set_cell(vector, 1, Vector2i(4,3))
