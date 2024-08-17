extends Sprite2D

@onready var shelf: Shelf = $".."

# 92%, 3rd stage, changed so we can tell when its full this is 11/12
# 40%, 2nd stage
# Below that 1st stage
# 0%, Nothing

func updateStockSprite():
	if not shelf.itemNum == 0:
		visible = true
		if get_filled_percentage() >= 0.92:
			region_rect.position.x = 0
		elif get_filled_percentage() >= 0.4:
			region_rect.position.x = 32
		else:
			region_rect.position.x = 64
	else:
		visible = false


func get_filled_percentage() -> float:
	return shelf.itemNum / shelf.maxItemCount 
