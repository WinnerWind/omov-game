@tool
extends Path2D
class_name CarPath

var speed:float:
	set(new_speed):
		speed = new_speed if new_speed >= 0 else initial_speed
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var initial_speed:float
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var raycast_distance:float = 100:
	set(new):
		raycast_distance = new
		if is_node_ready(): set_variables()
@export_group("Visuals")
@export var texture:Texture2D:
	set(new):
		texture = new
		if is_node_ready(): set_variables()
@export var texture_scale:float:
	set(new):
		texture_scale = new
		if is_node_ready(): set_variables()
var collision_shape:Shape2D
@export_tool_button("Reload All Visuals") var reload_visuals_script:Callable = set_variables
@export_group("Car Modifiers")
@export_range(0,1,0.1) var crash_car_in_pothole_chance:float = 0.0
@export var ignore_stop_signs:bool = false
@export_group("Nodes")
@export var sprite:Sprite2D
@export var detector_collision_object:CollisionShape2D
@export var path_follow:PathFollow2D
@export var raycast:RayCast2D

signal crashed()
signal path_complete()

func _ready() -> void:
	speed = initial_speed
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not raycast.is_colliding():
			var distance = curve.get_baked_length()
			var time_taken = distance/speed
			path_follow.progress_ratio += delta / time_taken # Move object in time_taken seconds.
			if path_follow.progress_ratio >= 0.99: #Reached the end of path
				path_complete.emit()
				free()
func set_variables():
	if sprite and texture:
		sprite.texture = texture
		sprite.scale = Vector2i.ONE * texture_scale
	if raycast:
		raycast.target_position.x = raycast_distance
	if detector_collision_object and collision_shape:
		detector_collision_object.shape = collision_shape
	if sprite and texture and detector_collision_object:
		var shape = RectangleShape2D.new()
		shape.size = texture.get_size() * sprite.scale
		detector_collision_object.shape = shape

func crash() -> void:
	crashed.emit()
	self.queue_free()

func entered_slowdown(slowdown_speed:float) -> void:
	var is_crash := randf_range(0,1) < crash_car_in_pothole_chance
	speed = slowdown_speed if not ignore_stop_signs and slowdown_speed == 0 else speed
	if is_crash: crash()

func _on_collision_detector_area_entered(area: Area2D) -> void:
	if not area is SlowdownArea: #Ensure we collided with a car
		var path:CarPath = area.owner
		path.crash()
		crash()
