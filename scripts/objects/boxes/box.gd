extends Node2D

class_name box
	
@export var itemNum = 10
@export var itemType : ItemGlobal.FoodTypes

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getItemName():
	print(itemType)

func disablePickup():
	get_node("CollisionShape2D").disabled = true
	
func enablePickup():
	get_node("CollisionShape2D").disabled = false

func pickUpCoolDown():
	$Timer.start()
	

func hideSprite():
	self.hide()
	
func showSprite():
	self.show()
	
func getName() -> ItemGlobal.FoodTypes:
	return itemType

#autobox pickup
func _on_body_entered(body):
	if body == $"../../Player" && $"../../Player".heldItem == null:
		$"../../Player".pickUpBox(self) 
		
	else: 
		pass # Replace with function body.


func _on_timer_timeout():
	print("can pick up now")
	self.enablePickup()
	pass # Replace with function body.
