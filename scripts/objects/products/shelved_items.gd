extends Sprite2D

class_name ShelvedItems

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

func update_product_type(arg: ItemGlobal.FoodTypes) -> void:
	match arg:
		0:
			texture = preload("res://textures/objects/products/shelved_canned_food_atlas.tres")
		1:
			texture = preload("res://textures/objects/products/shelved_cereal_atlas.tres")
		2:
			texture = preload("res://textures/objects/products/shelved_catnip_atlas.tres")
	print("tyna match to ", arg)
