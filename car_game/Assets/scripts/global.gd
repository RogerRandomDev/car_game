extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var min_speed = 384
var max_speed = 640
var min_max = 2048
var max_max = 3072
var min_traction = 5.0
var max_traction = 7.5
var min_traction_loss = 0.5
var max_traction_loss = 1.5
var min_turn_speed = 0.125
var max_turn_speed = 0.5
var min_decel = 0.125
var max_decel = 0.75
var min_accel = 0.25
var max_accel = 1.25
func _ready():randomize()

func generate_car_stats():
	var stats = [
		rand_range(min_speed,max_speed),
		rand_range(min_traction,max_traction),
		rand_range(min_traction_loss,max_traction_loss),
		rand_range(min_turn_speed,max_turn_speed),
		rand_range(min_accel,max_accel),
		rand_range(min_decel,max_decel),
		rand_range(min_max,max_max)
	]
	return stats


func get_middle_point(a,b):
	return Vector2(sqrt(pow(a.x,2)+pow(b.x,2)),sqrt(pow(a.y,2)+pow(b.y,2)))
