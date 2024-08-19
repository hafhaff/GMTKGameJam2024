extends Node

class_name ItemGlobal

enum FoodTypes {CANNED, CEREAL, CATNIP}

var FoodValues: Dictionary = {
	FoodTypes.CANNED : {purchasePrice = 2, sellPrice = 4},
	FoodTypes.CEREAL : {purchasePrice = 2, sellPrice = 5},
	FoodTypes.CATNIP : {purchasePrice = 5, sellPrice = 10}
}
