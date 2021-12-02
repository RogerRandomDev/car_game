extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var road_segments = 32
export var segment_spacing = 2048
export var segment_max_offset = 512
# Called when the node enters the scene tree for the first time.
func _ready():
	var prev_offset = Vector2.ZERO
	for segment in road_segments+1:
		prev_offset += Vector2(rand_range(-segment_max_offset,segment_max_offset),rand_range(-segment_max_offset,segment_max_offset))
		prev_offset.x = clamp(prev_offset.x,-segment_max_offset,segment_max_offset)
		prev_offset.y = clamp(prev_offset.y,-segment_max_offset,segment_max_offset)
		add_point(
			Vector2(0,segment_spacing).rotated(((2*PI)/road_segments)*segment)+
			prev_offset.rotated(((2*PI)/road_segments)*segment)
			)
		if segment == road_segments:
			set_point_position(segment,get_point_position(0))
		else:
			var area = Area2D.new()
			var col = CollisionShape2D.new()
			col.shape = RectangleShape2D.new()
			col.shape.extents = Vector2(64,1024+512)
			area.add_child(col)
			area.connect("body_entered",self,"check_bod",[area])
			add_child(area)
			area.position = get_point_position(segment)
		if segment != 0:
			#collision
			var coll = CollisionShape2D.new()
			coll.shape = RectangleShape2D.new()
			coll.shape.extents = Vector2(
				(
				get_point_position(segment-1)+Vector2(0,512).rotated(((2*PI/road_segments)*segment-1))-get_point_position(segment)+Vector2(0,512).rotated(((2*PI/road_segments)*segment))
				).length()/2,16)
			coll.position = get_point_position(segment-1)+Vector2(0,1024).rotated(((2*PI/road_segments)*segment))+(get_point_position(segment)-get_point_position(segment-1))/2
			$StaticBody2D.add_child(coll)
			coll.rotation =get_point_position(segment-1).angle_to_point(get_point_position(segment))
			var coll_in = CollisionShape2D.new()
			coll_in.shape = RectangleShape2D.new()
			coll_in.shape.extents = Vector2(
				(get_point_position(segment-1)-Vector2(0,256).rotated(((2*PI/road_segments)*segment-1))-get_point_position(segment)-Vector2(0,256).rotated(((2*PI/road_segments)*segment))
				).length()/2,16)
			coll_in.position = get_point_position(segment-1)-Vector2(0,1024).rotated(((2*PI/road_segments)*segment))+(get_point_position(segment)-get_point_position(segment-1))/2
			$StaticBody2D.add_child(coll_in)
			coll_in.rotation =get_point_position(segment-1).angle_to_point(get_point_position(segment))
	for segment in road_segments:
		if segment != road_segments-1:
			get_child(segment+2).look_at(get_point_position(segment+2))
		else:
			get_child(segment+2).look_at(get_point_position(0))
	var cur_car = 0
	for car in get_tree().get_nodes_in_group("Car"):
		car.position = get_point_position(0)+Vector2(96,96)*Vector2(round((cur_car/3)-0.5),cur_car%3)
		car.look_at(get_point_position(1))
		car.rotation+=PI/2
		car.cur_point = -1
		cur_car += 1
	get_child(0).points = points
	get_tree().get_nodes_in_group("minimap")[0].get_child(0).points = points

func check_bod(body,checkpoint):
	if !body.is_in_group("Car"):return
	if body.cur_point <= checkpoint.get_position_in_parent()-2:
		body.change_point()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
