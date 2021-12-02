extends KinematicBody2D


# Declare member variables here. Examples:
#statistics of vehicle
export var move_speed = 512
export var max_speed = 1024
export var accel = 0.5
export var decel = 0.25
export var turn_speed = 0.25
export var traction = 0.25
export var traction_loss = 1.5
export var player = false

var target_pos = Vector2.ZERO
var velocity = Vector2(0,0)
#pathfinding helpers
var cur_point = 0
export var point_offset = 128
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var stats = Global.generate_car_stats()
	move_speed=stats[0]
	traction = stats[1]
	traction_loss = stats[2]
	turn_speed = 1/(stats[3])
	accel = 1/stats[4]
	decel = 1/stats[5]
	max_speed = stats[6]
	
	var road = get_tree().get_nodes_in_group("Road")[0]
	cur_point += 1
	target_pos = road.get_point_position(cur_point)+(
		Vector2(0,rand_range(-point_offset,point_offset)).rotated(
		road.get_child(cur_point).rotation)
	)
func _process(delta):
	var new_dir = get_move_dir()
	rotation = lerp_angle(rotation,new_dir.x-PI/2,turn_speed*delta)
	
	var base_velocity = velocity.rotated(-rotation)
	base_velocity.y += abs(base_velocity.x)*traction*sign(base_velocity.y)*delta
	base_velocity.x -= base_velocity.x*traction*traction_loss*delta
	velocity = base_velocity.rotated(rotation)
	if velocity.rotated(-rotation).y < 0:
		velocity -= velocity*decel*delta
	velocity += Vector2(0,new_dir.y).rotated(rotation)*delta*accel
	velocity = velocity.clamped(max_speed)
	move_and_slide(velocity,Vector2.UP.rotated(rotation))
func get_move_dir():
	var dir = Vector2.ZERO
	if !player:
		var angle = rotation
		look_at(target_pos)
		dir.x = rotation
		rotation = angle
		dir.y = move_speed
	else:
		pass
	if is_on_ceiling():
		velocity = Vector2.ZERO
		dir.x = 1000000
	return dir

func change_point():
	var road = get_tree().get_nodes_in_group("Road")[0]
	cur_point += 1
	if cur_point >= road.road_segments:
		cur_point = 0
	target_pos = road.get_point_position(cur_point)+(
		Vector2(0,rand_range(-point_offset,point_offset)).rotated(
		road.get_child(cur_point+2).rotation)
	)
