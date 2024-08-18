extends NavmeshUpdater

class_name ExpansionMap

#include Vector2i()
#TODO: Add walls in this
func newChunk(xNode, yNode):
	for x in 10:
		for y in 10:
			set_cell(Vector2i(xNode + x, yNode + y), 0 ,Vector2i(4,3))
	
func _ready():
	global_shop._registerTilemap(self)

func _removeNavmeshFromTile(vector: Vector2i):
	set_cell(vector, 0, Vector2i(4,3))

func _addNavmeshToTile(vector: Vector2i):
	set_cell(vector, 1, Vector2i(4,3))
