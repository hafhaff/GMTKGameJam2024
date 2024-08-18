extends TileMapLayer

class_name NavmeshUpdater

#@onready var tileDataPolygon: NavigationPolygon = get_cell_tile_data(Vector2(1,1)).get_navigation_polygon(0)

func _ready():
	global_shop._registerTilemap(self)

func _removeNavmeshFromTile(vector: Vector2i):
	print("Removing navmesh")
	set_cell(vector, 1, Vector2i(4,3))

func _addNavmeshToTile(vector: Vector2i):
	set_cell(vector, 0, Vector2i(4,3))
