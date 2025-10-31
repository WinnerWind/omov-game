extends Node
class_name CarSpawnerManager

@export var spawners:Array[CarSpawner]

@export var number_of_vehicles_to_spawn:int

signal all_cars_spawned()
signal all_cars_cleared()

var spawners_complete:int #number of spawners in which all cars have spawned
var spawners_cleared:int #number of spawners in which all cars have cleared.

func _ready() -> void:
	for spawner in spawners:
		spawner.all_cars_spawned.connect(_spawner_cars_spawned)
		spawner.all_cars_cleared.connect(_spawner_cars_cleared)

func increase_wave():
	spawners_cleared = 0
	spawners_complete = 0
	for spawner in spawners:
		spawner.number_of_vehicles_to_spawn = number_of_vehicles_to_spawn

func _spawner_cars_cleared():
	spawners_cleared += 1
	print("Spawners that cleared: %s"%spawners_cleared)
	if spawners_cleared == spawners.size():
		all_cars_cleared.emit()
func _spawner_cars_spawned():
	spawners_complete += 1
	print("Spawners that completed: %s"%spawners_complete)
	if spawners_complete == spawners.size():
		all_cars_spawned.emit()
