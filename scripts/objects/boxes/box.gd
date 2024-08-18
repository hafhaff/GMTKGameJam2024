@tool
extends Area2D

class_name Box
	
@export var itemNum = 10
@export var itemType : ItemGlobal.FoodTypes

@onready var base: Sprite2D = $Base

signal selfYeet(Box)	#Called on self destruction
signal pickedUp(Box, bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	global_shop._addBox(self)
	update_box_type(self.itemType)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#update box type in editor
	if Engine.is_editor_hint():
		update_box_type(self.itemType)
	
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

# Customization
func update_box_type(index: int) -> void:
	base.region_rect.position.x = index * 32 
