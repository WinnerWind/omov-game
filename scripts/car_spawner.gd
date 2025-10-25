extends Node2D
class_name CarSpawner

@export var max_delay:float
@export var min_delay:float
@export var number_of_vehicles_to_spawn:int:
	set(new):
		number_of_vehicles_to_spawn = new
		vehicles_spawned = 0
var vehicles_spawned:int = 0
var delay:
	get:
		return randf_range(min_delay,max_delay)
@export var curves:Array[Curve2D]
@export_group("Internal")
@export var car_packed:PackedScene
@export var bus_packed:PackedScene
@export var bike_packed:PackedScene
var timer:Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(queue_spawn)
	timer.start(delay)

var last_curve:Curve2D
func queue_spawn() -> void:
	if not vehicles_spawned >= number_of_vehicles_to_spawn:
		var rand := randf()
		var vehicle:CarPath
		if rand < 0.2: #car spawn
			vehicle = car_packed.instantiate()
		elif rand < 0.5: #bike spawn
			vehicle = bike_packed.instantiate()
		else: #bus spawn
			vehicle = bus_packed.instantiate()
		
		var curve:Curve2D = curves.pick_random()
		
		#Find a unique curve so we don't spawn in the same place twice in a row
		while curve == last_curve: curve = curves.pick_random()
		last_curve = curve
		vehicle.curve = curve
		add_child(vehicle)
		timer.start(delay)
		vehicles_spawned += 1

func reverse_curve2d_points(curve:Curve2D) -> Curve2D:
	#https://forum.godotengine.org/t/can-we-reverse-path2d-direction-in-godot/50018
	var new_curve=Curve2D.new()
	for i in range(curve.point_count-1,-1,-1):
		new_curve.add_point(curve.get_point_position(i))
	return new_curve
