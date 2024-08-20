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
	
	if shelf.itemNum == null or shelf.maxItemCount == null:
		return 0
	
	return shelf.itemNum / shelf.maxItemCount

func update_product_type(arg: ItemGlobal.FoodTypes) -> void:
	match arg:
		0:
			texture = preload("res://textures/objects/products/shelved_canned_food_atlas.tres")
		1:
			texture = preload("res://textures/objects/products/shelved_cereal_atlas.tres")
		2:
			texture = preload("res://textures/objects/products/shelved_catnip_atlas.tres")
		3:
			texture = preload("res://textures/objects/products/shelved_milk.tres")
		4:
			texture = preload("res://textures/objects/products/shelved_drinks.tres")
		5:
			texture = preload("res://textures/objects/products/shelved_ice_cream.tres")
	print("tyna match to ", arg)
