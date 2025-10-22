extends Node2D

@export var wave_number:int

@export_group("Nodes")
@export var car_spawner:CarSpawner
@export var pothole_spawner:PotholeSpawner
func _ready() -> void:
	pothole_spawner.number_of_potholes_to_spawn = wave_number
	car_spawner.number_of_cars_to_spawn = wave_number
	
	pothole_spawner.spawn_potholes()
