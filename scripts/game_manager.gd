extends Node2D
class_name GameManager

@export var wave_number:int = 0

var potholes_this_wave:int:
	get:
		if wave_number >= 5:
			return int (
				((pow(((wave_number + 4.2)/
				100),1.1) ) + 5 ) * 5.9  - 25
			) #nice formula senator, why don't you back it up with a source?
		else: return 0 
var cars_this_wave:int:
	get:
		return int(
			(wave_number + 10) / 0.2 * pow(1.2,0.2)
		)

@export var pothole_powerup_uses:int = 10
@export var bbmp_powerup_uses:int = 10

@export_group("Nodes")
@export var car_spawner:CarSpawnerManager
@export var pothole_spawner:PotholeSpawner

signal bbmp_powerup_used()

signal number_of_potholes_changed(num:int)
signal number_of_bbmp_changed(num:int)

func wave_increase():
	print("WAVE INCREASE --- No. %s - cars %s  potholes %s"%[wave_number,cars_this_wave,potholes_this_wave])
	wave_number += 1
	car_spawner.number_of_vehicles_to_spawn = cars_this_wave
	car_spawner.increase_wave()
	
	pothole_spawner.number_of_potholes_to_spawn = potholes_this_wave
	pothole_spawner.queue_spawn_pothole()
	
	number_of_bbmp_changed.emit(bbmp_powerup_uses)
	number_of_potholes_changed.emit(potholes_this_wave)

func wave_ended():
	print("Wave has ended!")
	wave_increase()

func _use_pothole_powerup() -> void:
	if pothole_powerup_uses > 0:
		var cleared:bool = %PotholeSpawner.clear_random_pothole()
		if cleared: pothole_powerup_uses -= 1
		else: pass #cannot clear the pothole

func _use_bbmp_powerup() -> void:
	bbmp_powerup_used.emit()

enum GameOverReasons {DEADLOCK,CRASH,TOO_SLOW}
func game_over(reason:GameOverReasons) -> void:
	print(reason)
