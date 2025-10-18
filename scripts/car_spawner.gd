extends Node2D
class_name CarSpawner

@export var car_packed:PackedScene
@export var curves:Array[Curve2D]
func _ready() -> void:
	for i in 10:
		var car:CarPath = car_packed.instantiate()
		car.curve = curves.pick_random()
		add_child(car)
