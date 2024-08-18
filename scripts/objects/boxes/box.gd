@tool
extends Area2D

class_name Box
	
@export var itemNum = 10
@export var itemType : ItemGlobal.FoodTypes

@onready var box_display: BoxDisplay = $BoxDisplay

signal selfYeet(Box)	#Called on self destruction
signal pickedUp(Box, bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	global_shop._addBox(self)
	
	# Set display
	update_box_type()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		update_box_type()
	
func getItemName():
	print(itemType)

func disablePickup():
	get_node("CollisionShape2D").disabled = true
	pickedUp.emit(self, true)
	
func enablePickup():
	get_node("CollisionShape2D").disabled = false
	pickedUp.emit(self, false)

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
	self.enablePickup()
	pass # Replace with function body.

func removeSelf():
	selfYeet.emit(self)
	queue_free()

# Change the texture to the current type
func update_box_type():
	box_display.itemType = self.itemType
