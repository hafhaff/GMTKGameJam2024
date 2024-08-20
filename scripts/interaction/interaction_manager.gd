extends Node2D

class_name InteractionManager

var active_areas: Array = []
var can_interact: bool = true


func register_area(area: Shelf):
	active_areas.push_back(area)


func unregister_area(area: Shelf):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(delta):
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)


func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = position.distance_to(area1.global_position)
	var area2_to_player = position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func get_active_area() -> Shelf:
	if active_areas.size() > 0:
		return active_areas[0]
	else: return null
