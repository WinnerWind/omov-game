extends Node2D
class_name CarSpawner

@export var max_delay:float
@export var min_delay:float
var delay:
	get:
		return randf_range(min_delay,max_delay)
@export var curves:Array[Curve2D]
@export_group("Internal")
@export var car_packed:PackedScene
@export var timer:Timer

func _ready() -> void:
	timer.timeout.connect(queue_spawn)
	timer.start(delay)

func queue_spawn() -> void:
	var car:CarPath = car_packed.instantiate()
	car.curve = curves.pick_random()
	add_child(car)
	timer.start(delay)
