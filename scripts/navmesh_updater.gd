extends TileMapLayer

class_name NavmeshUpdater

func _ready():
	global_shop._registerTilemap(self)

func _removeNavmeshFromTile(vector: Vector2i):
	print("Removing navmesh")
	set_cell(vector, 1, Vector2i(4,3))

func _addNavmeshToTile(vector: Vector2i):
	set_cell(vector, 0, Vector2i(4,3))
