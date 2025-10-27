@tool
extends Area2D
class_name SlowdownArea

@export var apply_effect:bool:
	set(new_var):
		apply_effect = new_var
		if is_node_ready():
			collision_shape.set_deferred(&"disabled", !apply_effect)
@export var slowdown_speed:float
@export var shape:Shape2D:
	set(new):
		shape = new
		if is_node_ready(): set_variables()
@export_tool_button("Reload All Visuals") var reload_visuals_script:Callable = set_variables
@export_group("Internal")
@export var collision_shape:CollisionShape2D
@export var toggle_button:CheckButton
var affected_cars:Array[CarPath]

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_exited.connect(_on_body_exited)
	if toggle_button:
		toggle_button.size = shape.size

func _on_body_entered(body:Node2D):
	if body.owner is CarPath: #must be a car
		var path:CarPath = body.owner
		path_entered(path)
		affected_cars.append(path)

func _on_body_exited(body:Node2D):
	if body.owner is CarPath: #must be a car
		var path:CarPath = body.owner
		path_exited(path)
		affected_cars.erase(path)

func path_entered(path:CarPath):
	var new_speed := path.speed - slowdown_speed
	path.speed = new_speed if new_speed > 0 else 25

func path_exited(path:CarPath):
	path.speed = -1


func toggle_stopped_state(state):
	apply_effect = state
func set_variables() -> void:
	collision_shape.shape = shape
