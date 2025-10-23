extends Node2D

@export var wave_number:int

var potholes_this_wave:int:
	get:
		if wave_number >= 5:
			return int (
				((pow(((wave_number + 4.2)/
				100),1.1) ) + 5 ) * 5.9  - 17
			) #nice formula senator, why don't you back it up with a source?
		else: return 0 
var cars_this_wave:int:
	get:
		return int(
			(wave_number + 10) / 0.2 * pow(1.2,0.2)
		)
@export_group("Nodes")
@export var car_spawner:CarSpawner
@export var pothole_spawner:PotholeSpawner

func wave_increase():
	wave_number += 1
	car_spawner.number_of_cars_to_spawn = cars_this_wave
	car_spawner.queue_spawn()
	
	pothole_spawner.number_of_potholes_to_spawn = potholes_this_wave
	pothole_spawner.spawn_potholes()
