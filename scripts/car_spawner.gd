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
		vehicle.curve = curves.pick_random()
		add_child(vehicle)
		timer.start(delay)
		vehicles_spawned += 1
