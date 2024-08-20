extends Node

class_name ItemGlobal

enum FoodTypes {CANNED, CEREAL, CATNIP, MILK, DRINKS, ICE_CREAM}

var FoodValues: Dictionary = {
	FoodTypes.CANNED : {purchasePrice = 2, sellPrice = 4},
	FoodTypes.CEREAL : {purchasePrice = 2, sellPrice = 5},
	FoodTypes.CATNIP : {purchasePrice = 5, sellPrice = 10},
	FoodTypes.MILK : {purchasePrice = 5, sellPrice = 10},
	FoodTypes.DRINKS : {purchasePrice = 5, sellPrice = 10},
	FoodTypes.ICE_CREAM : {purchasePrice = 5, sellPrice = 10}
}
