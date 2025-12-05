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
		) - 51

@export var pothole_powerup_uses:int = 10
@export var bbmp_powerup_uses:int = 10

@export_group("Nodes")
@export var car_spawner:CarSpawnerManager
@export var pothole_spawner:PotholeSpawner

signal bbmp_powerup_used()

signal number_of_potholes_powerup_changed(num:int)
signal number_of_bbmp_changed(num:int)

func wave_increase():
	wave_number += 1
	print("WAVE INCREASE --- No. %s - cars %s  potholes %s"%[wave_number,cars_this_wave,potholes_this_wave])
	car_spawner.number_of_vehicles_to_spawn = cars_this_wave
	car_spawner.increase_wave()
	
	pothole_spawner.number_of_potholes_to_spawn = potholes_this_wave
	pothole_spawner.queue_spawn_pothole()
	
	number_of_bbmp_changed.emit(bbmp_powerup_uses)
	number_of_potholes_powerup_changed.emit(pothole_powerup_uses)
	print(pothole_powerup_uses)

func wave_ended():
	print("Wave has ended!")
	%"Day Ended".open()

func _use_pothole_powerup() -> void:
	if pothole_powerup_uses > 0:
		var cleared:bool = %PotholeSpawner.clear_random_pothole()
		if cleared: pothole_powerup_uses -= 1
		else: pass #cannot clear the pothole
		number_of_potholes_powerup_changed.emit(pothole_powerup_uses)

func _use_bbmp_powerup() -> void:
	var bbmp_active:bool = %Spawners.only_spawn_buses
	if bbmp_powerup_uses > 0 and not bbmp_active:
		bbmp_powerup_used.emit()
		bbmp_powerup_uses -= 1
		number_of_bbmp_changed.emit(bbmp_powerup_uses)

enum GameOverReasons {DEADLOCK,CRASH,TOO_SLOW}
func game_over(reason:GameOverReasons) -> void:
	var citation_screen:GameOverCitation = %"Game Over Screen"
	citation_screen.intro()
	citation_screen.show()
	var title:String = "CITATION"
	var content:String
	match reason:
		GameOverReasons.DEADLOCK: content = "Dommasandra had a complete deadlock!"
		GameOverReasons.CRASH: content = "Two vehicles collided with each other!"
		GameOverReasons.TOO_SLOW: content = "Cars were not moving fast enough!"
	var button_dictionary:Dictionary[String,Callable] = {"Restart": get_tree().reload_current_scene, "Main Menu": func(): print("Hello World")}
	citation_screen.set_content(title, content , wave_number, 0)
	citation_screen.set_buttons(button_dictionary)
	%Spawners.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	#%Spawners.process_mode = Node.PROCESS_MODE_DISABLED

func get_game_over_position(pos):
	$Camera.game_over_zoom_in(pos)
func _ready() -> void:
	wave_increase()
