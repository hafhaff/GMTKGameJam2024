extends TileMapLayer

class_name NavmeshUpdater

@onready var tileDataPolygon: NavigationPolygon = get_cell_tile_data(Vector2(1,1)).get_navigation_polygon(0)

func _ready():
	global_shop._registerTilemap(self)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var vector: Vector2 = (floor(get_global_mouse_position()/32))
		if event.button_index == MOUSE_BUTTON_LEFT:
			#get_cell_tile_data(vector).set_navigation_polygon(0,null)
			set_cell(vector, 3, Vector2i(0,0))
		if event.button_index == MOUSE_BUTTON_RIGHT:
			#get_cell_tile_data(vector).set_navigation_polygon(0,tileDataPolygon)
			set_cell(vector, 4, Vector2i(0,0))

func _removeNavmeshFromTile(vector: Vector2i):
	set_cell(vector, 0, Vector2i(0,0))

func _addNavmeshToTile(vector: Vector2i):
	set_cell(vector, 3, Vector2i(0,0))
