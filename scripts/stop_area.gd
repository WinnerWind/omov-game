@tool
extends Area2D
class_name StopArea

@export var stop_cars:bool
@export var shape:RectangleShape2D:
	set(new):
		shape = new
		if is_node_ready(): set_variables()
@export_tool_button("Reload All Visuals") var reload_visuals_script:Callable = set_variables
@export_group("Internal")
@export var collision_shape:CollisionShape2D
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

func set_variables() -> void:
	collision_shape.shape = shape
