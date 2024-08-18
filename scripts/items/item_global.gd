extends Node

class_name ItemGlobal

enum FoodTypes {CANNED, CEREAL, CATNIP}

var FoodValues: Dictionary = {
	FoodTypes.CANNED : {purchasePrice = 1, sellPrice = 2},
	FoodTypes.CEREAL : {purchasePrice = 1, sellPrice = 2},
	FoodTypes.CATNIP : {purchasePrice = 1, sellPrice = 2}
}
