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

var curves:Array[Curve2D]

var car_packed:PackedScene = preload("res://scenes/prefabs/vehicles/car.tscn")
var bus_packed:PackedScene = preload("res://scenes/prefabs/vehicles/bus.tscn")
var bike_packed:PackedScene = preload("res://scenes/prefabs/vehicles/bike.tscn")

var timer:Timer
var spawner_signal_emitted:bool

signal all_cars_spawned()
signal all_cars_cleared()

func _ready() -> void:
	# fetch paths from child Path2Ds
	for child in get_children():
		if child is Path2D and child.curve:
			curves.append(child.curve)
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(queue_spawn)
	timer.start(delay)


func queue_spawn() -> void:
	if not vehicles_spawned >= number_of_vehicles_to_spawn:
		spawner_signal_emitted = false
		var rand := randf()
		var vehicle:CarPath
		if rand < 0.2: #car spawn
			vehicle = car_packed.instantiate()
		elif rand < 0.5: #bike spawn
			vehicle = bike_packed.instantiate()
		else: #bus spawn
			vehicle = bus_packed.instantiate()
		
		var curve:Curve2D = curves.pick_random()
		
		vehicle.crashed.connect(check_all_cars_finished)
		vehicle.path_complete.connect(check_all_cars_finished)
		
		vehicle.curve = curve
		add_child(vehicle)
		timer.start(delay)
		vehicles_spawned += 1
	else:
		if not spawner_signal_emitted:
			all_cars_spawned.emit()
			spawner_signal_emitted = true
		

func check_all_cars_finished():
	await get_tree().process_frame
	var cars:Array[CarPath]
	if not vehicles_spawned >= number_of_vehicles_to_spawn: #still cars to spawn
		return 
	for child in get_children():
		if child is CarPath: cars.append(child)
	if cars == []:
		all_cars_cleared.emit()

func reverse_curve2d_points(curve:Curve2D) -> Curve2D:
	#https://forum.godotengine.org/t/can-we-reverse-path2d-direction-in-godot/50018
	var new_curve=Curve2D.new()
	for i in range(curve.point_count-1,-1,-1):
		new_curve.add_point(curve.get_point_position(i))
	return new_curve
