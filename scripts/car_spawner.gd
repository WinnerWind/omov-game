extends Node2D
class_name CarSpawner

@export var max_delay:float
@export var min_delay:float
@export var number_of_cars_to_spawn:int:
	set(new):
		number_of_cars_to_spawn = new
		cars_spawned = 0
var cars_spawned:int = 0
var delay:
	get:
		return randf_range(min_delay,max_delay)
@export var curves:Array[Curve2D]
@export_group("Internal")
@export var car_packed:PackedScene
@export var timer:Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(queue_spawn)
	timer.start(delay)

func queue_spawn() -> void:
	if not cars_spawned >= number_of_cars_to_spawn:
		var car:CarPath = car_packed.instantiate()
		car.curve = curves.pick_random()
		add_child(car)
		timer.start(delay)
		cars_spawned += 1
