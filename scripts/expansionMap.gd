extends NavmeshUpdater

class_name ExpansionMap

#include Vector2i()
#TODO: Add walls in this
func newChunk(topLeftTile):
	for x in 10:
		for y in 10:
			set_cell(Vector2i(topLeftTile.x + x, topLeftTile.y + y), 0 ,Vector2i(4,3))
	
func _ready():
	global_shop._registerTilemap(self)

func _removeNavmeshFromTile(vector: Vector2i):
	set_cell(vector, 0, Vector2i(0,0))

func _addNavmeshToTile(vector: Vector2i):
	set_cell(vector, 3, Vector2i(0,0))
