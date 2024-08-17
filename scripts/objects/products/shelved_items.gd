extends Sprite2D

@onready var shelf: Shelf = $".."

# 90%, 3rd stage
# 40%, 2nd stage
# Below that 1st stage
# 0%, Nothing

@export var debug_percentage: float

func _process(delta: float) -> void:
	if not shelf.itemNum == 0:
		visible = true
		if get_filled_percentage() >= 0.9:
			region_rect.position.x = 0
		elif get_filled_percentage() >= 0.4:
			region_rect.position.x = 32
		else:
			region_rect.position.x = 64
	else:
		visible = false

func get_filled_percentage() -> float:
	return shelf.maxItemCount / shelf.itemNum
