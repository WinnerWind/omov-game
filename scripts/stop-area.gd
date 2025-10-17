extends Area2D
class_name StopArea

@export var stop_cars:bool:
	set(new_var):
		stop_cars = new_var
		for car in stopped_cars: car.stopped = stop_cars
var stopped_cars:Array[CarPath]

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body:Node2D):
	if body is CharacterBody2D and body.get_parent().get_parent() is CarPath: #must be a car
		var path:CarPath = body.get_parent().get_parent()
		path.stopped = stop_cars
		stopped_cars.append(path)

func _on_body_exited(body:Node2D):
	if body is CharacterBody2D and body.get_parent().get_parent() is CarPath: #must be a car
		var path:CarPath = body.get_parent().get_parent()
		stopped_cars.erase(path)
