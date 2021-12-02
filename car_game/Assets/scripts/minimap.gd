extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	for car in get_tree().get_nodes_in_group("Car"):
		var carr = load("res://Assets/Scenes/car_map.tscn").instance()
		$MinimapPath.add_child(carr)
	var time = Timer.new()
	time.wait_time = 0.05
	time.connect("timeout",self,'_update_minimap')
	add_child(time)
	time.start()
# Called when the node enters the scene tree for the first time.
func _update_minimap():
	var car_count = 0
	for car in get_tree().get_nodes_in_group("Car"):
		$MinimapPath.get_child(car_count).position = car.position
		car_count += 1
