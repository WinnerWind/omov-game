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
@export var collision_shape:RectangleShape2D:
	set(new):
		collision_shape = new
		if is_node_ready(): set_variables()
@export_tool_button("Reload All Visuals") var reload_visuals_script:Callable = set_variables
@export_group("Nodes")
@export var sprite:Sprite2D
@export var detector_collision_object:CollisionShape2D
@export var path_follow:PathFollow2D
@export var raycast:RayCast2D

var stopped:bool #Used to stop the car for various circumstances.
func _ready() -> void:
	speed = initial_speed
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not stopped and not raycast.is_colliding():
			var distance = curve.get_baked_length()
			var time_taken = distance/speed
			path_follow.progress_ratio += delta / time_taken # Move object in time_taken seconds.
func set_variables():
	if sprite and texture:
		sprite.texture = texture
	if raycast:
		raycast.target_position.x = raycast_distance
	if detector_collision_object and collision_shape:
		detector_collision_object.shape = collision_shape

func _on_collision_detector_area_entered(area: Area2D) -> void:
	if not area is SlowdownArea: #Ensure we collided with a car
		var path:CarPath = area.owner
		#print("Collision!")
		path.queue_free()
		self.queue_free()
